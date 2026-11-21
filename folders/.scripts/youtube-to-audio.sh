#!/usr/bin/env bash
# YouTube to Audio Downloader with cookies support

set -e

# --- Configuration ---
DEFAULT_OUTPUT_DIR="$HOME/Music/YouTube"
DEFAULT_COOKIES_FILE="$HOME/.config/youtube-cookies.txt"
VALID_FORMATS=("mp3" "m4a" "opus" "flac" "wav")
DEFAULT_FORMAT="mp3"
QUALITY="320k"

# --- Functions ---
print_help() {
    echo "YouTube to Audio Downloader"
    echo "Usage: $0 [OPTIONS] <YouTube_URL>"
    echo ""
    echo "Options:"
    echo "  -o, --output DIR      Output directory (default: $DEFAULT_OUTPUT_DIR)"
    echo "  -f, --format FORMAT   Audio format: ${VALID_FORMATS[*]} (default: $DEFAULT_FORMAT)"
    echo "  -q, --quality QUALITY Audio quality (default: $QUALITY)"
    echo "  -c, --cookies FILE    Cookies file for authentication"
    echo "  --browser BROWSER     Extract cookies from browser (firefox/chrome/brave)"
    echo "  --no-cookies          Don't use cookies"
    echo "  -p, --playlist        Download entire playlist"
    echo "  -l, --list-formats    List available audio formats"
    echo "  -h, --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 https://youtu.be/example"
    echo "  $0 --browser firefox https://youtube.com/watch?v=example"
    echo "  $0 --no-cookies -f opus -o ~/Music/Classical https://youtube.com/watch?v=example"
}

check_dependencies() {
    if ! command -v yt-dlp &> /dev/null; then
        echo "Error: yt-dlp is not installed"
        echo "Install it with: nix-shell -p yt-dlp"
        exit 1
    fi
    
    if ! command -v ffmpeg &> /dev/null; then
        echo "Error: ffmpeg is not installed"
        echo "Install it with: nix-shell -p ffmpeg"
        exit 1
    fi
}

# --- Main script ---
main() {
    check_dependencies
    
    local url=""
    local output_dir="$DEFAULT_OUTPUT_DIR"
    local cookies_file=""
    local browser=""
    local use_cookies=true
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
                shift 2
                ;;
            -q|--quality)
                quality="$2"
                shift 2
                ;;
            -c|--cookies)
                cookies_file="$2"
                shift 2
                ;;
            --browser)
                browser="$2"
                shift 2
                ;;
            --no-cookies)
                use_cookies=false
                shift
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
                echo "Error: Unknown option $1"
                print_help
                exit 1
                ;;
            *)
                url="$1"
                shift
                ;;
        esac
    done
    
    if [ -z "$url" ]; then
        echo "Error: YouTube URL is required"
        print_help
        exit 1
    fi
    
    if [ "$list_formats" = true ]; then
        echo "Available formats for: $url"
        echo ""
        CMD="yt-dlp -F \"$url\""
        if [ "$use_cookies" = true ] && [ -n "$browser" ]; then
            CMD="$CMD --cookies-from-browser $browser"
        elif [ "$use_cookies" = true ] && [ -n "$cookies_file" ] && [ -f "$cookies_file" ]; then
            CMD="$CMD --cookies \"$cookies_file\""
        fi
        eval "$CMD" | grep -E "audio only|video only" | head -20
        exit 0
    fi
    
    mkdir -p "$output_dir"
    
    # Build command
    CMD="yt-dlp"
    
    # Add playlist option
    if [ "$is_playlist" = true ]; then
        CMD="$CMD --yes-playlist"
    else
        CMD="$CMD --no-playlist"
    fi
    
    # Add audio extraction options
    CMD="$CMD -x"
    
    # Add format and quality
    case "$format" in
        mp3)
            CMD="$CMD --audio-format mp3 --audio-quality $quality"
            ;;
        m4a|opus|flac|wav)
            CMD="$CMD --audio-format $format"
            ;;
        *)
            CMD="$CMD --audio-format best"
            ;;
    esac
    
    # Add metadata
    CMD="$CMD --embed-thumbnail --add-metadata"
    
    # Add output template
    CMD="$CMD -o \"$output_dir/%(title)s.%(ext)s\""
    
    # Handle cookies
    if [ "$use_cookies" = true ]; then
        if [ -n "$browser" ]; then
            echo "🔐 Using cookies from $browser browser..."
            CMD="$CMD --cookies-from-browser $browser"
        elif [ -n "$cookies_file" ] && [ -f "$cookies_file" ]; then
            echo "🍪 Using cookies from: $cookies_file"
            CMD="$CMD --cookies \"$cookies_file\""
        elif [ -f "$DEFAULT_COOKIES_FILE" ]; then
            echo "🍪 Using default cookies from: $DEFAULT_COOKIES_FILE"
            CMD="$CMD --cookies \"$DEFAULT_COOKIES_FILE\""
        else
            echo "⚠️  No cookies available, trying without..."
            echo
