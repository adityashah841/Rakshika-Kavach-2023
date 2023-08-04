import json
import numpy as np
from fastapi import FastAPI, UploadFile,File
from fastapi.responses import JSONResponse
from model.model import extract_faces
from pydantic import BaseModel
from secrets import token_hex
import uvicorn
# from app.model.model import predict_pipeline
# from app.model.model import __version__ as model_version


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
    # file_ext = file.filename.split(".").pop()
    # file_name = token_hex(10)
    # file_path = f"media/videos/{file_name}.{file_ext}"
    # with open(file_path,"wb") as f:
    #     content = await file.read()
    #     f.write(content)
    # return {"success": True, "file_path":file_path}
    face_images = extract_faces(file, payload.evidence_id,payload.aadhar)
    return JSONResponse({'response': face_images})


if __name__ == "__main__":
    uvicorn.run("main:app", host = "127.0.0.1", reload = True)