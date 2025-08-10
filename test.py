from utils.solve import solve_captcha
from pathlib import Path
from PIL import Image
image_path = Path("d.png") 
if not image_path.exists():
    raise FileNotFoundError(f"Image not found: {image_path}")

# Load the image
img = Image.open(image_path)

captcha_val = solve_captcha(img)
print(captcha_val)