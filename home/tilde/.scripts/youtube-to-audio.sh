#!/usr/bin/env bash

# YouTube to Audio Downloader
# Downloads video from YouTube and extracts audio track only

set -e

# --- Configuration ---
DEFAULT_OUTPUT_DIR="$HOME/Music/YouTube"
VALID_FORMATS=("mp3" "m4a" "opus" "flac" "wav")
DEFAULT_FORMAT="mp3"
QUALITY="320k"  # For MP3 format

# --- Colors for output ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- Functions ---
print_help() {
    echo -e "${GREEN}YouTube to Audio Downloader${NC}"
    echo "Usage: $0 [OPTIONS] <YouTube_URL>"
    echo ""
    echo "Options:"
    echo "  -o, --output DIR      Output directory (default: $DEFAULT_OUTPUT_DIR)"
    echo "  -f, --format FORMAT   Audio format: ${VALID_FORMATS[*]} (default: $DEFAULT_FORMAT)"
    echo "  -q, --quality QUALITY Audio quality (default: $QUALITY)"
    echo "  -p, --playlist        Download entire playlist"
    echo "  -l, --list-formats    List available audio formats for the video"
    echo "  -h, --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 https://youtu.be/example"
    echo "  $0 -f opus -o ~/Music/Classical https://youtube.com/watch?v=example"
    echo "  $0 -p https://youtube.com/playlist?list=example"
}

check_dependencies() {
    local missing=()
    
    if ! command -v yt-dlp &> /dev/null; then
        missing+=("yt-dlp")
    fi
    
    if ! command -v ffmpeg &> /dev/null; then
        missing+=("ffmpeg")
    fi
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${RED}Error: Missing dependencies:${NC} ${missing[*]}"
        echo "Install them with:"
        echo "  nix-shell -p yt-dlp ffmpeg"
        exit 1
    fi
}

validate_format() {
    local format="$1"
    for valid in "${VALID_FORMATS[@]}"; do
        if [ "$format" = "$valid" ]; then
            return 0
        fi
    done
    return 1
}

create_output_dir() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        echo -e "${YELLOW}Creating output directory: $dir${NC}"
        mkdir -p "$dir"
    fi
}

get_video_title() {
    local url="$1"
    yt-dlp --get-title --no-warnings "$url" 2>/dev/null | head -1
}

download_audio() {
    local url="$1"
    local output_dir="$2"
    local format="$3"
    local quality="$4"
    local is_playlist="$5"
    
    echo -e "${BLUE}Processing:${NC} $url"
    
    # Get video title for display
    local title
    title=$(get_video_title "$url")
    if [ -n "$title" ]; then
        echo -e "${BLUE}Title:${NC} $title"
    fi
    
    # Build yt-dlp command
    local cmd="yt-dlp"
    
    # Add playlist option if needed
    if [ "$is_playlist" = true ]; then
        cmd="$cmd --yes-playlist"
    else
        cmd="$cmd --no-playlist"
    fi
    
    # Configure output template
    local output_template="$output_dir/%(title)s.%(ext)s"
    
    # Set format based on desired output
    case "$format" in
        mp3)
            # Download best audio and convert to MP3
            cmd="$cmd -x --audio-format mp3 --audio-quality $quality"
            cmd="$cmd --embed-thumbnail --add-metadata"
            cmd="$cmd -o '$output_template'"
            ;;
        m4a|opus|flac|wav)
            # Download in specific format
            cmd="$cmd -x --audio-format $format"
            cmd="$cmd --embed-thumbnail --add-metadata"
            cmd="$cmd -o '$output_template'"
            ;;
        *)
            # Best available audio
            cmd="$cmd -x --audio-format best"
            cmd="$cmd --embed-thumbnail --add-metadata"
            cmd="$cmd -o '$output_template'"
            ;;
    esac
    
    # Add the URL
    cmd="$cmd '$url'"
    
    echo -e "${YELLOW}Downloading audio...${NC}"
    echo -e "${BLUE}Command:${NC} $cmd"
    echo ""
    
    # Execute the command
    eval "$cmd"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Successfully downloaded audio${NC}"
        echo -e "${GREEN}Output directory:${NC} $output_dir"
    else
        echo -e "${RED}✗ Failed to download audio${NC}"
        return 1
    fi
}

list_formats() {
    local url="$1"
    echo -e "${YELLOW}Available formats for:${NC} $url"
    echo ""
    yt-dlp -F "$url" | grep -E "audio only|video only" | head -20
}

# --- Main script ---
main() {
    # Check dependencies first
    check_dependencies
    
    # Parse arguments
    local url=""
    local output_dir="$DEFAULT_OUTPUT_DIR"
    local format="$DEFAULT_FORMAT"
    local quality="$QUALITY"
    local is_playlist=false
    local list_formats=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                print_help
                exit 0
                ;;
            -o|--output)
                output_dir="$2"
                shift 2
                ;;
            -f|--format)
                format="$2"
                if ! validate_format "$format"; then
                    echo -e "${RED}Error: Invalid format '$format'${NC}"
                    echo -e "Valid formats: ${VALID_FORMATS[*]}"
                    exit 1
                fi
                shift 2
                ;;
            -q|--quality)
                quality="$2"
                shift 2
                ;;
            -p|--playlist)
                is_playlist=true
                shift
                ;;
            -l|--list-formats)
                list_formats=true
                shift
                ;;
            -*)
                echo -e "${RED}Error: Unknown option $1${NC}"
                print_help
                exit 1
                ;;
            *)
                url="$1"
                shift
                ;;
        esac
    done
    
    # Validate URL
    if [ -z "$url" ]; then
        echo -e "${RED}Error: YouTube URL is required${NC}"
        print_help
        exit 1
    fi
    
    # Create output directory
    create_output_dir "$output_dir"
    
    # List formats if requested
    if [ "$list_formats" = true ]; then
        list_formats "$url"
        exit 0
    fi
    
    # Download audio
    download_audio "$url" "$output_dir" "$format" "$quality" "$is_playlist"
}

# Run main function
main "$@"
