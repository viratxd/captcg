#!/bin/bash
# install_and_setup_tesseract.sh
# Usage: ./install_and_setup_tesseract.sh [models_dir]
# If models_dir is not provided, it defaults to the current directory

models_folder="models"

echo "[*] Using models folder: $models_folder"

# Create models directory
mkdir -p "$models_folder"
cd "$models_folder" || exit 1

# Install system dependencies
echo "[*] Installing system packages..."
sudo apt-get update
sudo apt-get install -y tesseract-ocr wget python3-pip

# Install Python dependencies
echo "[*] Installing Python packages..."
pip install --upgrade pip
pip install opencv-python imgcat Pillow numpy pytesseract

# Download models
echo "[*] Downloading Tesseract model files..."
files=("LICENSE" 'lstm/eng.traineddata' 'lstm/osd.traineddata' 'old/eng.traineddata' 'old/myconfig')

for f in "${files[@]}"; do
    d=$(dirname "$f")
    mkdir -p "$d"
    wget "https://storage.googleapis.com/lgd_captcha_tesseract_models/$f" -O "$f"
done

# Update whitelist in myconfig
echo "[*] Updating myconfig whitelist..."
sed 's/^tessedit_char_whitelist .*/tessedit_char_whitelist 0123456789abcdefghijklmnopqrstuvwxyz/' old/myconfig > old/myconfig.new
mv old/myconfig.new old/myconfig

# Set TESSDATA_PREFIX (optional — can also be done in .bashrc)
export TESSDATA_PREFIX="$models_folder"
if ! grep -q "TESSDATA_PREFIX" ~/.bashrc; then
    echo "export TESSDATA_PREFIX=\"$models_folder\"" >> ~/.bashrc
fi

echo "[*] Done! You may need to restart your terminal for TESSDATA_PREFIX to take effect."
