from fastapi import FastAPI, UploadFile,File
from fastapi.responses import JSONResponse
from model.model import extract_faces
from pydantic import BaseModel
import uvicorn


app = FastAPI(title="Rakshika")

class Evidence(BaseModel):
    videofile: str
    evidence_id: str
    aadhar: str

@app.get("/")
def home():
    return {"health_check": "OK"}


@app.post("/extract")
async def predict(payload : Evidence):
    file = payload.videofile
    face_images = extract_faces(file, payload.evidence_id)
    return JSONResponse({'response': face_images})


if __name__ == "__main__":
    uvicorn.run("main:app", host = "127.0.0.1", reload = True)