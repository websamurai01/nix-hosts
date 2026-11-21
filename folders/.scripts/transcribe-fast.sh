#!/usr/bin/env bash

# --- ENTRY POINT: FHS WRAPPER CHECK ---
if [ -z "$_IN_NIXOS_FHS" ]; then
    echo ":: Entering NixOS FHS environment (for CUDA/Pip compatibility)..."
    
    # 1. Создаем файл окружения (исправлено buildFHSUserEnv -> buildFHSEnv)
    cat <<EOF > /tmp/whisper-fhs.nix
{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:
(pkgs.buildFHSEnv {
  name = "whisper-fhs";
  targetPkgs = pkgs: with pkgs; [
    # Системные библиотеки
    udev
    alsa-lib
    zlib
    
    # Инструменты
    python3
    uv
    ffmpeg
    git
    
    # CUDA (Библиотеки для вычислений)
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    linuxPackages.nvidia_x11
  ];
  runScript = "bash";
  profile = ''
    export _IN_NIXOS_FHS=1
    # Важно: добавляем путь к драйверам Nvidia в NixOS
    export LD_LIBRARY_PATH="/usr/lib:/usr/lib64:/run/opengl-driver/lib:\$LD_LIBRARY_PATH"
  '';
}).env
EOF
    
    # 2. Запускаем nix-shell с этим файлом
    exec nix-shell /tmp/whisper-fhs.nix --run "$0 $*"
fi

# ==============================================================================
# КОД ВНУТРИ ОКРУЖЕНИЯ
# ==============================================================================

set -e

# --- CONFIGURATION ---
MODEL_SIZE="medium"    # medium ~5GB VRAM
DEVICE="cuda"          # GPU
COMPUTE_TYPE="float16" # Turing (GTX 1660) native
LANGUAGE="ru"

# --- COLORS ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

input_file="$1"
output_file="${2:-transcription.txt}"

if [ -z "$input_file" ]; then
    echo "Usage: $(basename "$0") <audio_file> [output_file]"
    exit 1
fi

echo -e "${BLUE}:: Initializing Fast Transcriber (GTX 1660 / FHS Mode)...${NC}"

# --- VIRTUAL ENVIRONMENT ---
VENV_DIR="$HOME/.cache/whisper-fast-venv"

if [ ! -d "$VENV_DIR" ]; then
    echo -e "${BLUE}:: Creating venv...${NC}"
    uv venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"

# Проверка и установка пакета
if ! python3 -c "import faster_whisper" &> /dev/null; then
    echo -e "${BLUE}:: Installing engine...${NC}"
    uv pip install faster-whisper
fi

# --- WORKER ---
python3 - <<EOF
import sys
import time
import os
from faster_whisper import WhisperModel

input_path = "$input_file"
output_path = "$output_file"
model_size = "$MODEL_SIZE"
device = "$DEVICE"
compute_type = "$COMPUTE_TYPE"
lang = "$LANGUAGE"

def format_timestamp(seconds):
    hours = int(seconds // 3600)
    minutes = int((seconds % 3600) // 60)
    secs = int(seconds % 60)
    return f"{hours:02d}:{minutes:02d}:{secs:02d}"

try:
    print(f"${GREEN}:: Loading Model ({model_size})...${NC}")
    # local_files_only=False позволяет скачать модель
    model = WhisperModel(model_size, device=device, compute_type=compute_type)

    print(f"${GREEN}:: Processing Audio...${NC}")
    segments, info = model.transcribe(input_path, beam_size=5, language=lang)

    print(f":: Duration: {info.duration:.2f}s")
    
    with open(output_path, "w", encoding="utf-8", buffering=1) as f:
        f.write(f"Source: {input_path}\nModel: {model_size}\n{'-'*50}\n\n")
        
        for segment in segments:
            ts = format_timestamp(segment.start)
            line = f"[{ts}] {segment.text}"
            
            # Print to console
            sys.stdout.write(f"\r\033[K{line[:80]}...")
            sys.stdout.flush()
            
            # Write to file
            f.write(line + "\n")
    
    print(f"\n\n${GREEN}:: Done! Saved to: {os.path.abspath(output_path)}${NC}")

except Exception as e:
    print(f"\n${RED}:: Error: {e}${NC}")
    sys.exit(1)
EOF
