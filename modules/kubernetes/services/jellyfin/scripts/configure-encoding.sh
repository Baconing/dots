set -euo pipefail

# Grab our variables
NODE=$(cat /etc/podinfo/node-name)
LABELS=$(kubectl get node "$NODE" -o json)

GPU_TYPE=$(echo "$LABELS" | jq -r '.metadata.labels["gpu.type"] // "none"')
ENCODE_LIST=$(echo "$LABELS" | jq -r '.metadata.labels["gpu.encode"] // ""')
DECODE_LIST=$(echo "$LABELS" | jq -r '.metadata.labels["gpu.decode"] // ""')
TONEMAPPING=$(echo "$LABELS" | jq -r '.metadata.labels["gpu.tonemapping"] // "false"')

# Set GPU vendor based variables.
case "$GPU_TYPE" in
  nvidia)
    ENABLE=true
    TYPE=nvenc
    NVDEC=true
    ;;
  amd|intel)
    ENABLE=true
    TYPE=vaapi
    NVDEC=false
    ;;
  *)
    ENABLE=false
    TYPE=none
    NVDEC=false
    ;;
esac

# Set encoding variables
ALLOW_HEVC_ENCODING=false
ALLOW_AV1_ENCODING=false

IFS=',' read -ra ENCODE <<< "$ENCODE_LIST"
for c in "${ENCODE[@]}"; do
  case "$c" in
    hevc) ALLOW_HEVC_ENCODING=true ;;
    av1)  ALLOW_AV1_ENCODING=true ;;
  esac
done

# Set decoding xml variables
ALLOWED_DECODE_CODECS="
h264
vc1
av1
vp9
mpeg2video
vp8
hevc
"

CODECS_XML=""

IFS=',' read -ra DECODE <<< "$DECODE_LIST"
for codec in "${DECODE[@]}"; do
  if echo "$ALLOWED_DECODE_CODECS" | grep -qx "$codec"; then
    CODECS_XML="$CODECS_XML    <string>$codec</string>\n"
  fi
done

if [ "$ENABLE" = true ] && [ -z "$CODECS_XML" ]; then
  echo "ERROR: GPU enabled but no decode codecs allowed" >&2
  exit 1
fi

# Delete the old encoding config (just in case) and render our template.

rm /config/encoding.xml

sed \
  -e "s|@HWACCEL@|$ENABLE|g" \
  -e "s|@HWACCEL_TYPE@|$TYPE|g" \
  -e "s|@NVDEC@|$NVDEC|g" \
  -e "s|@TONEMAPPING@|$TONEMAPPING|g" \
  -e "s|@ALLOW_HEVC_ENCODING@|$ALLOW_HEVC_ENCODING|g" \
  -e "s|@ALLOW_AV1_ENCODING@|$ALLOW_AV1_ENCODING|g" \
  -e "s|@HW_DECODE_CODECS@|$CODECS_XML|g" \
  /templates/encoding.xml.tpl \
  > /config/encoding.xml
