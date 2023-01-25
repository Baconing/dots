if [[ "$1" == "togglesink" ]]; then
  pactl set-sink-mute @DEFAULT_SINK@ toggle
  if [[ "$(pactl get-sink-mute @DEFAULT_SINK@)" == "Mute: no" ]]; then
    notify-send -u low -a Audio "Audio unmuted."
  else
    notify-send -u low -a Audio "Audio muted."
  fi
elif [[ "$1" == "togglesource" ]]; then
  pactl set-source-mute @DEFAULT_SOURCE@ toggle
  if [[ "$(pactl get-source-mute @DEFAULT_SOURCE@)" ==  "Mute: no" ]]; then
    notify-send -u low -a Audio "Microphone unmuted."
  else
    notify-send -u low -a Audio "Microphone muted."
  fi
else
  pactl set-sink-volume @DEFAULT_SINK@ $1
  notify-send -u low -a Audio "Volume: $(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')%"
fi
