#!/usr/bin/env bash
# MP3 to Text Transcriber
# Converts MP3 files to text using Whisper and merges them into one file

set -e

# --- Configuration ---
DEFAULT_OUTPUT_FILE="transcription.txt"
WHISPER_MODEL="base"  # Options: tiny, base, small, medium, large
LANGUAGE="ru"  # Language code: ru, en, etc. Leave empty for auto-detection

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- Functions ---
print_help() {
    echo -e "${GREEN}MP3 to Text Transcriber${NC}"
    echo "Converts MP3 files to text using Whisper AI and merges results"
    echo ""
    echo "Usage: $0 [OPTIONS] <mp3_file1> [mp3_file2 ...]"
    echo ""
    echo "Options:"
    echo "  -o, --output FILE     Output text file (default: $DEFAULT_OUTPUT_FILE)"
    echo "  -m, --model MODEL     Whisper model: tiny, base, small, medium, large (default: $WHISPER_MODEL)"
    echo "  -l, --lang LANGUAGE   Language code: ru, en, etc. (default: $LANGUAGE, empty for auto)"
    echo "  -t, --temp DIR        Temporary directory (default: /tmp/whisper-XXXXXX)"
    echo "  -k, --keep-temp       Keep temporary files after processing"
    echo "  -v, --verbose         Show detailed output"
    echo "  -h, --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 audio1.mp3 audio2.mp3"
    echo "  $0 -o result.txt -m medium *.mp3"
    echo "  $0 -l en --verbose podcast/*.mp3"
    echo ""
    echo "Dependencies:"
    echo "  - whisper-ctranslate2 (pip install whisper-ctranslate2)"
    echo "  - ffmpeg (for audio processing)"
    echo "  - python3 with whisper module"
}

check_dependencies() {
    local missing=()
    
    # Check for whisper-ctranslate2 or openai-whisper
    if ! python3 -c "import whisper" 2>/dev/null && ! python3 -c "import whisper_ctranslate2" 2>/dev/null; then
        echo -e "${YELLOW}Warning: Neither 'whisper' nor 'whisper-ctranslate2' Python packages found.${NC}"
        echo "Install one of them:"
        echo "  pip install openai-whisper    # Original (slower)"
        echo "  pip install whisper-ctranslate2  # Faster with CTranslate2"
        echo "Or install system-wide:"
        echo "  nix-shell -p python3 python3Packages.whisper"
        missing+=("whisper")
    fi
    
    if ! command -v ffmpeg &> /dev/null; then
        echo -e "${RED}Error: ffmpeg is not installed${NC}"
        echo "Install with: nix-shell -p ffmpeg"
        missing+=("ffmpeg")
    fi
    
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}Error: python3 is not installed${NC}"
        missing+=("python3")
    fi
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${RED}Missing dependencies:${NC} ${missing[*]}"
        exit 1
    fi
}

detect_whisper_backend() {
    # Check which whisper backend is available
    if python3 -c "import whisper_ctranslate2" 2>/dev/null; then
        echo "ctranslate2"
    elif python3 -c "import whisper" 2>/dev/null; then
        echo "openai"
    else
        echo "none"
    fi
}

transcribe_with_whisper() {
    local input_file="$1"
    local output_file="$2"
    local model="$3"
    local language="$4"
    local backend="$5"
    local verbose="$6"
    
    echo -e "${BLUE}Processing:${NC} $(basename "$input_file")"
    
    if [ "$verbose" = true ]; then
        echo -e "  Model: $model, Language: ${language:-auto}, Backend: $backend"
    fi
    
    # Check if file exists
    if [ ! -f "$input_file" ]; then
        echo -e "${RED}Error: File not found: $input_file${NC}"
        return 1
    fi
    
    # Check file size
    local file_size=$(stat -c%s "$input_file" 2>/dev/null || stat -f%z "$input_file" 2>/dev/null)
    if [ "$file_size" -lt 1000 ]; then
        echo -e "${YELLOW}Warning: File is very small ($file_size bytes), may not contain audio${NC}"
    fi
    
    # Create Python script for transcription
    local python_script=""
    
    if [ "$backend" = "ctranslate2" ]; then
        python_script=$(cat << EOF
import whisper_ctranslate2
import sys
import json

model = whisper_ctranslate2.load_model("$model")
result = model.transcribe(
    "$input_file",
    language="$language" if "$language" else None,
    verbose=$verbose
)

# Write to output file
with open("$output_file", "w", encoding="utf-8") as f:
    f.write(result["text"])
    
# Also print some info
print(f"  Duration: {result['segments'][-1]['end']:.1f}s")
print(f"  Text length: {len(result['text'])} chars")
EOF
        )
    elif [ "$backend" = "openai" ]; then
        python_script=$(cat << EOF
import whisper
import sys
import torch

# Check if CUDA is available
device = "cuda" if torch.cuda.is_available() else "cpu"
print(f"  Using device: {device}")

model = whisper.load_model("$model")
result = model.transcribe(
    "$input_file",
    language="$language" if "$language" else None,
    verbose=$verbose
)

# Write to output file
with open("$output_file", "w", encoding="utf-8") as f:
    f.write(result["text"])
    
print(f"  Duration: {result['segments'][-1]['end']:.1f}s")
print(f"  Text length: {len(result['text'])} chars")
EOF
        )
    else
        echo -e "${RED}Error: No whisper backend available${NC}"
        return 1
    fi
    
    # Run the Python script
    if [ "$verbose" = true ]; then
        echo -e "  Starting transcription..."
    fi
    
    # Create a temporary Python file
    local temp_py=$(mktemp)
    echo "$python_script" > "$temp_py"
    
    # Execute Python script with error handling
    if ! python3 "$temp_py"; then
        echo -e "${RED}Error: Transcription failed for $input_file${NC}"
        rm -f "$temp_py"
        return 1
    fi
    
    rm -f "$temp_py"
    return 0
}

main() {
    # Check dependencies first
    check_dependencies
    
    # Parse arguments
    local output_file="$DEFAULT_OUTPUT_FILE"
    local model="$WHISPER_MODEL"
    local language="$LANGUAGE"
    local temp_dir=""
    local keep_temp=false
    local verbose=false
    local input_files=()
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                print_help
                exit 0
                ;;
            -o|--output)
                output_file="$2"
                shift 2
                ;;
            -m|--model)
                model="$2"
                shift 2
                ;;
            -l|--lang)
                language="$2"
                shift 2
                ;;
            -t|--temp)
                temp_dir="$2"
                shift 2
                ;;
            -k|--keep-temp)
                keep_temp=true
                shift
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            -*)
                echo -e "${RED}Error: Unknown option $1${NC}"
                print_help
                exit 1
                ;;
            *)
                input_files+=("$1")
                shift
                ;;
        esac
    done
    
    # Check if we have input files
    if [ ${#input_files[@]} -eq 0 ]; then
        echo -e "${RED}Error: No input files specified${NC}"
        print_help
        exit 1
    fi
    
    # Create temporary directory
    if [ -z "$temp_dir" ]; then
        temp_dir=$(mktemp -d "/tmp/whisper-XXXXXX")
    else
        mkdir -p "$temp_dir"
    fi
    
    echo -e "${GREEN}=== MP3 to Text Transcriber ===${NC}"
    echo -e "Input files: ${#input_files[@]}"
    echo -e "Output file: $output_file"
    echo -e "Model: $model"
    echo -e "Language: ${language:-auto-detect}"
    echo -e "Temp dir: $temp_dir"
    echo ""
    
    # Detect whisper backend
    local backend=$(detect_whisper_backend)
    if [ "$backend" = "none" ]; then
        echo -e "${RED}Error: No whisper backend found${NC}"
        echo "Install one with: pip install whisper-ctranslate2"
        exit 1
    fi
    echo -e "${BLUE}Using backend:${NC} $backend"
    
    # Process each file
    local success_count=0
    local fail_count=0
    local transcriptions=()
    
    for input_file in "${input_files[@]}"; do
        if [ ! -f "$input_file" ]; then
            echo -e "${RED}File not found: $input_file${NC}"
            fail_count=$((fail_count + 1))
            continue
        fi
        
        # Create temp output file for this transcription
        local temp_output=$(mktemp -p "$temp_dir" "transcript-XXXXXX.txt")
        local base_name=$(basename "$input_file")
        
        echo -e "\n${BLUE}--- Processing: $base_name ---${NC}"
        
        if transcribe_with_whisper "$input_file" "$temp_output" "$model" "$language" "$backend" "$verbose"; then
            success_count=$((success_count + 1))
            transcriptions+=("$temp_output")
            
            # Show preview of transcription
            if [ "$verbose" = true ]; then
                echo -e "${GREEN}Preview:${NC}"
                head -c 200 "$temp_output" | cat -A
                echo "..."
            fi
        else
            fail_count=$((fail_count + 1))
        fi
    done
    
    # Merge all transcriptions
    echo -e "\n${GREEN}=== Merging results ===${NC}"
    
    if [ ${#transcriptions[@]} -eq 0 ]; then
        echo -e "${RED}No successful transcriptions to merge${NC}"
        if [ "$keep_temp" = false ]; then
            rm -rf "$temp_dir"
        fi
        exit 1
    fi
    
    # Create output file with header
    {
        echo "# Transcription Results"
        echo "# Generated: $(date)"
        echo "# Model: $model, Language: ${language:-auto}"
        echo "# Files processed: ${success_count}/${#input_files[@]}"
        echo ""
        
        for i in "${!transcriptions[@]}"; do
            local input_file="${input_files[$i]}"
            local transcript="${transcriptions[$i]}"
            
            echo ""
            echo "="*60
            echo "File: $(basename "$input_file")"
            echo "Path: $input_file"
            echo "Size: $(du -h "$input_file" | cut -f1)"
            echo "="*60
            echo ""
            
            cat "$transcript"
            echo ""
        done
    } > "$output_file"
    
    echo -e "${GREEN}✓ Successfully merged ${success_count} transcriptions into:${NC} $output_file"
    echo -e "  Total files: ${#input_files[@]}, Successful: $success_count, Failed: $fail_count"
    
    # Show summary
    if [ "$verbose" = true ]; then
        echo -e "\n${BLUE}=== Summary ===${NC}"
        echo -e "Output file size: $(du -h "$output_file" | cut -f1)"
        echo -e "Total characters: $(wc -m < "$output_file")"
        echo -e "Total lines: $(wc -l < "$output_file")"
    fi
    
    # Cleanup
    if [ "$keep_temp" = false ]; then
        echo -e "\n${YELLOW}Cleaning up temporary files...${NC}"
        rm -rf "$temp_dir"
    else
        echo -e "\n${YELLOW}Temporary files kept in:${NC} $temp_dir"
    fi
    
    # Final message
    echo -e "\n${GREEN}✅ Done! Transcription complete.${NC}"
}

# Run main function
main "$@"
