<!--
Variables:

============ These variables are used by kubernetes at runtime in the init script. ============
@HW_ACCEL@ - boolean
@HWACCEL_TYPE@ - one of nvenc, vaapi, or none
@ALLOW_HEVC_ENCODING@ - boolean
@ALLOW_AV1_ENCODING@ - boolean
@NVDEC@ - boolean
@TONEMAPPING@ - boolean

@HW_DECODE_CODECS@ - list of enums as <string></string> objects:
- h264
- vc1
- av1
- vp9
- mpeg2video
- vp8
- hevc
-->

<?xml version="1.0" encoding="utf-8"?>
<EncodingOptions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <HardwareAccelerationType>@HWACCEL_TYPE@</HardwareAccelerationType>
  <EnableEnhancedNvdecDecoder>@NVDEC@</EnableEnhancedNvdecDecoder>
  <EnableHardwareEncoding>@HW_ACCEL@</EnableHardwareEncoding>
  <AllowHevcEncoding>@ALLOW_HEVC_ENCODING@</AllowHevcEncoding>
  <AllowAv1Encoding>@ALLOW_AV1_ENCODING@</AllowAv1Encoding>
  <HardwareDecodingCodecs>
    @HW_DECODE_CODECS@
  </HardwareDecodingCodecs>

  <EnableTonemapping>@TONEMAPPING@</EnableTonemapping>

  <VaapiDevice>/dev/dri/renderD128</VaapiDevice>
  <QsvDevice />

  <EnableDecodingColorDepth10Hevc>true</EnableDecodingColorDepth10Hevc>
  <EnableDecodingColorDepth10Vp9>true</EnableDecodingColorDepth10Vp9>
  <EnableDecodingColorDepth10HevcRext>true</EnableDecodingColorDepth10HevcRext>
  <EnableDecodingColorDepth12HevcRext>true</EnableDecodingColorDepth12HevcRext>
  <PreferSystemNativeHwDecoder>true</PreferSystemNativeHwDecoder>
  <EnableIntelLowPowerH264HwEncoder>false</EnableIntelLowPowerH264HwEncoder>
  <EnableIntelLowPowerHevcHwEncoder>false</EnableIntelLowPowerHevcHwEncoder>

  <EnableVppTonemapping>false</EnableVppTonemapping>
  <EnableVideoToolboxTonemapping>false</EnableVideoToolboxTonemapping>
  <TonemappingAlgorithm>bt2390</TonemappingAlgorithm>
  <TonemappingMode>auto</TonemappingMode>
  <TonemappingRange>auto</TonemappingRange>
  <TonemappingDesat>0</TonemappingDesat>
  <TonemappingPeak>100</TonemappingPeak>
  <TonemappingParam>0</TonemappingParam>
  <VppTonemappingBrightness>16</VppTonemappingBrightness>
  <VppTonemappingContrast>1</VppTonemappingContrast>

  <EncodingThreadCount>-1</EncodingThreadCount>
  <EnableFallbackFont>false</EnableFallbackFont>
  <EnableAudioVbr>false</EnableAudioVbr>
  <DownMixAudioBoost>2</DownMixAudioBoost>
  <DownMixStereoAlgorithm>None</DownMixStereoAlgorithm>
  <MaxMuxingQueueSize>2048</MaxMuxingQueueSize>
  <EnableThrottling>false</EnableThrottling>
  <ThrottleDelaySeconds>180</ThrottleDelaySeconds>
  <EnableSegmentDeletion>false</EnableSegmentDeletion>
  <SegmentKeepSeconds>720</SegmentKeepSeconds>
  <H264Crf>23</H264Crf>
  <H265Crf>28</H265Crf>
  <EncoderPreset xsi:nil="true" />
  <DeinterlaceDoubleRate>false</DeinterlaceDoubleRate>
  <DeinterlaceMethod>yadif</DeinterlaceMethod>
  <EncoderAppPathDisplay>/usr/lib/jellyfin-ffmpeg/ffmpeg</EncoderAppPathDisplay>
  <EnableSubtitleExtraction>true</EnableSubtitleExtraction>
  <AllowOnDemandMetadataBasedKeyframeExtractionForExtensions>
    <string>mkv</string>
  </AllowOnDemandMetadataBasedKeyframeExtractionForExtensions>
</EncodingOptions>