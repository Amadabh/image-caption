# from transformers import VisionEncoderDecoderModel, ViTImageProcessor,AutoTokenizer,pipeline
# from optimum.onnxruntime import ORTModelForVision2Seq

# from PIL import Image
# from fastapi import FastAPI, File, UploadFile
# import io



# app = FastAPI()
# # image_to_text = pipeline("image-to-text", model=ORTModelForVision2Seq.from_pretrained("./onnx-image-captioning-model"),
# #                          tokenizer = AutoTokenizer.from_pretrained("nlpconnect/vit-gpt2-image-captioning"),
# #                          feature_extractor = ViTImageProcessor.from_pretrained("./onnx-image-captioning-model"))

# image_to_text = pipeline(
#     "image-to-text",
#     model=ORTModelForVision2Seq.from_pretrained("./onnx-image-captioning-model-quantized"),
#     tokenizer=AutoTokenizer.from_pretrained("./onnx-image-captioning-model-quantized"),
#     feature_extractor=ViTImageProcessor.from_pretrained("./onnx-image-captioning-model-quantized")
# )

# @app.post("/upload")
# async def upload(file: UploadFile = File(...)):
#     contents = await file.read()
#     image = Image.open(io.BytesIO(contents)).convert("RGB")
#     captions = image_to_text(image)
#     return {"captions": captions}


from fastapi import FastAPI, File, UploadFile
from transformers import pipeline, AutoTokenizer, ViTImageProcessor
from optimum.onnxruntime import ORTModelForVision2Seq
from PIL import Image
import io

app = FastAPI()

# Global variable but not loaded yet
image_to_text = None

def get_pipeline():
    global image_to_text
    if image_to_text is None:
        # Load model only once, when first needed
        image_to_text = pipeline(
            "image-to-text",
            model=ORTModelForVision2Seq.from_pretrained("./onnx-image-captioning-model-quantized"),
            tokenizer=AutoTokenizer.from_pretrained("./onnx-image-captioning-model-quantized"),
            feature_extractor=ViTImageProcessor.from_pretrained("./onnx-image-captioning-model-quantized")
        )
    return image_to_text

@app.post("/upload")
async def upload(file: UploadFile = File(...)):
    contents = await file.read()
    image = Image.open(io.BytesIO(contents)).convert("RGB")

    pipe = get_pipeline()   # load on first call, reuse later
    captions = pipe(image)

    return {"captions": captions}
