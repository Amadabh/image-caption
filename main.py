from transformers import VisionEncoderDecoderModel, ViTImageProcessor,AutoTokenizer,pipeline
from optimum.onnxruntime import ORTModelForVision2Seq

from PIL import Image
from fastapi import FastAPI, File, UploadFile
import io



app = FastAPI()
# image_to_text = pipeline("image-to-text", model=ORTModelForVision2Seq.from_pretrained("./onnx-image-captioning-model"),
#                          tokenizer = AutoTokenizer.from_pretrained("nlpconnect/vit-gpt2-image-captioning"),
#                          feature_extractor = ViTImageProcessor.from_pretrained("./onnx-image-captioning-model"))

image_to_text = pipeline(
    "image-to-text",
    model=ORTModelForVision2Seq.from_pretrained("./onnx-image-captioning-model-quantized"),
    tokenizer=AutoTokenizer.from_pretrained("./onnx-image-captioning-model-quantized"),
    feature_extractor=ViTImageProcessor.from_pretrained("./onnx-image-captioning-model-quantized")
)

@app.post("/upload")
async def upload(file: UploadFile = File(...)):
    contents = await file.read()
    image = Image.open(io.BytesIO(contents)).convert("RGB")
    captions = image_to_text(image)
    return {"captions": captions}