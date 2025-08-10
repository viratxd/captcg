from fastapi import APIRouter, File, UploadFile, HTTPException
from utils.solve import solve_captcha
from PIL import Image
import io

router = APIRouter()

@router.post("/solve", summary="Solve a CAPTCHA")
async def solve(file: UploadFile = File(...)):
    # Ensure uploaded file is an image
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="Invalid file type. Please upload an image.")

    try:
        image_bytes = await file.read()
        image = Image.open(io.BytesIO(image_bytes))
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Unable to read image: {str(e)}")

    try:
        text = solve_captcha(image)
        return {"captcha_text": text}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error solving captcha: {str(e)}")
