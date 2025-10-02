#!/bin/bash

# Start FastAPI (port 8000) in background
uvicorn main:app --host 0.0.0.0 --port 8000 &

# Start Streamlit (port 8501)
streamlit run app.py --server.port 8501 --server.address 0.0.0.0



# #!/bin/bash

# # Unzip ONNX model if it exists
# if [ -f "onnx-image-captioning-model-quantized.tar.gz" ]; then
#     echo "Extracting ONNX model..."
#     tar -xzf onnx-image-captioning-model-quantized.tar.gz
# fi

# # Start FastAPI (port 8000) in background
# uvicorn main:app --host 0.0.0.0 --port 8000 &

# # Start Streamlit (port 8501)
# streamlit run app.py --server.port 8501 --server.address 0.0.0.0



# # Extract model if not already extracted
# if [ ! -d "onnx-image-captioning-model-quantized" ]; then
#     tar -xzf /app/onnx-image-captioning-model-quantized.tar.gz -C /app
# fi
# # Start FastAPI in background
# uvicorn main:app --host 0.0.0.0 --port 8000 &

# # Start Streamlit in foreground
# streamlit run app.py --server.port 8501 --server.address 0.0.0.0