#!/bin/zsh

set -e

# Default values for options
out_dir=$PWD
video_filter="scale=\"ceil(iw/4)*2:ceil(ih/4)*2\""
avc_rate="320k"
hevc_rate="220k"
webm_rate="220k"
no_audio=""

# Function to print help message
print_help() {
  echo "Usage: ./script.sh -i input_vid [OPTIONS]"
  echo "Options:"
  echo "  -i, --input          Video file to process"
  echo "  -o  --out            Output directory"
  echo "  -f, --video-filter   Specify a video filter (default: scale=123)"
  echo "      --avc-rate       Set the bitrate for the AVC codec (default: 360k)"
  echo "      --hevc-rate      Set the bitrate for the HEVC codec (default: 260k)"
  echo "      --webm-rate      Set the bitrate for the WebM codec (default: 260k)"
  echo "      --no-audio       Remove audio stream"
  echo "  -h, --help           Print this help message"
}

function do_exec {
  cmd=$1
  echo ""
  echo "Will execute << $cmd >>"
  eval "${cmd}"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  -i | --input)
    input_vid=$2
    shift
    shift
    ;;
  -o | --out)
    out_dir=$2
    shift
    shift
    ;;
  -f | --video-filter)
    video_filter=$2
    shift
    shift
    ;;
  --avc-rate)
    avc_rate=$2
    shift
    shift
    ;;
  --hevc-rate)
    hevc_rate=$2
    shift
    shift
    ;;
  --webm-rate)
    webm_rate=$2
    shift
    shift
    ;;
  --no-audio)
    no_audio=-an
    shift
    ;;
  -h | --help)
    print_help
    exit 0
    ;;
  *)
    echo "Unrecognized option: $1"
    print_help
    exit 1
    ;;
  esac
done

# Check if input_vid argument was provided
if [[ -z $input_vid ]]; then
  echo "Error: input_vid argument is required"
  print_help
  exit 1
fi

# Check if input_vid file exists
if [[ ! -f $input_vid ]]; then
  echo "Error: $input_vid does not exist"
  print_help
  exit 1
fi

vid_file=$(basename ${input_vid})
vid_name=${vid_file%.*}

echo "Transcoding $input_vid -> $out_dir/${vid_name}.{webp,_hevc.mp4,_avc.mp4,.webm}"

# Extract first frame for the poster
do_exec "ffmpeg -y -i $input_vid -vframes 1  -f image2 -vf "$video_filter" ${out_dir}/${vid_name}.jpg"

# Convert it to WebP, because we're cool kids
do_exec "ffmpeg -y -i ${out_dir}/${vid_name}.jpg ${out_dir}/${vid_name}.webp"

# Transcode to H.264/AVC
do_exec "ffmpeg -y -i $input_vid ${no_audio} -c:v libx264    -vf "$video_filter" -b:v ${avc_rate}  -preset slower -pix_fmt yuv420p ${out_dir}/${vid_name}_avc.mp4"

# Transcode to H.265/HEVC
do_exec "ffmpeg -y -i $input_vid ${no_audio} -c:v libx265    -vf "$video_filter" -b:v ${hevc_rate} -preset slower -tag:v hvc1      ${out_dir}/${vid_name}_hevc.mp4"

# # Transcode to VP9, two passes
do_exec "ffmpeg -y -i $input_vid ${no_audio} -c:v libvpx-vp9 -vf "$video_filter" -b:v ${webm_rate} -pass 1  -f null /dev/null"
do_exec "ffmpeg -y -i $input_vid ${no_audio} -c:v libvpx-vp9 -vf "$video_filter" -b:v ${webm_rate} -pass 2  ${out_dir}/${vid_name}_vp9.webm"
