from fastapi import FastAPI
from routes import captcha
import uvicorn

app = FastAPI(title="Captcha Solver API", version="1.0")

# Include routes
app.include_router(captcha.router, prefix="/captcha", tags=["Captcha"])

@app.get("/", summary="Root endpoint")
def root():
    return {"message": "Captcha Solver API is running"}

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="0.0.0.0",   # Listen on all interfaces
        port=8000,
        reload=True       # Only for development
    )
