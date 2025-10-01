from optimum.onnxruntime import ORTQuantizer,ORTModelForVision2Seq
from onnxruntime.quantization import quantize_dynamic,QuantType
from transformers import ViTImageProcessor, AutoTokenizer
from optimum.onnxruntime.configuration import AutoQuantizationConfig

print("Exporting model to ONNX...")

# Export model
model = ORTModelForVision2Seq.from_pretrained(
    "nlpconnect/vit-gpt2-image-captioning", 
    export=True
)
model.save_pretrained("./onnx-image-captioning-model")


print("Saving feature extractor and tokenizer...")
# Save feature extractor properly
feature_extractor = ViTImageProcessor.from_pretrained("nlpconnect/vit-gpt2-image-captioning")
feature_extractor.save_pretrained("./onnx-image-captioning-model")


print("Saving tokenizer...")
# Save tokenizer
tokenizer = AutoTokenizer.from_pretrained("nlpconnect/vit-gpt2-image-captioning")
tokenizer.save_pretrained("./onnx-image-captioning-model")

print("✅ Model exported to ONNX successfully!")




model_path = "./onnx-image-captioning-model"
save_dir = "./onnx-image-captioning-model-quantized"

qconfig = AutoQuantizationConfig.avx512_vnni(is_static=False)

# List of ONNX files to quantize
onnx_files = [
    "encoder_model.onnx",
    "decoder_model.onnx",
    "decoder_with_past_model.onnx",
]

for fname in onnx_files:
    print(f"Quantizing {fname} ...")

    quantize_dynamic(
        model_path +"/"+ fname,
        fname + "_quantized.onnx", 
        weight_type = QuantType.QInt8  # must re-specify so it overwrites correctly
    )