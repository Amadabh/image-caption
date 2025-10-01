FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install uv

# RUN uv pip install --system --no-cache-dir torch torchvision torchaudio \
#     --index-url https://download.pytorch.org/whl/cpu

RUN uv pip install --system --no-cache-dir \
    torch==2.2.0+cpu torchvision==0.17.0+cpu \
    --find-links https://download.pytorch.org/whl/torch_stable.html

RUN uv pip install --system --no-cache-dir "numpy<2" --force-reinstall
RUN uv pip install --system --no-cache-dir -r requirements.txt
 

# Copy compressed model
# COPY onnx-image-captioning-model-quantized.tar.gz .
# RUN tar -xzf onnx-image-captioning-model-quantized.tar.gz && rm onnx-image-captioning-model-quantized.tar.gz


COPY main.py app.py start.sh ./

RUN chmod +x start.sh

EXPOSE 8000 8501

CMD ["./start.sh"]


# FROM python:3.10-slim

# WORKDIR /app

# # Install uv (copy from official image - fastest method)
# RUN pip install uv

# # Copy requirements
# COPY requirements.txt .

# # Install dependencies with minimal transformers
# RUN uv pip install --system --no-cache-dir \
#     fastapi==0.118.0 \
#     uvicorn==0.37.0 \
#     pillow==11.0.0 \
#     streamlit==1.50.0 \
#     numpy==2.1.2 \
#     onnxruntime==1.23.0 \
#     optimum==1.16.0

# # Install transformers without optional dependencies
# RUN uv pip install --system --no-cache-dir \
#     --no-deps transformers==4.53.3 && \
#     uv pip install --system --no-cache-dir \
#     huggingface-hub tokenizers safetensors regex requests tqdm packaging filelock pyyaml

# # Clean up unnecessary files from packages
# RUN find /usr/local/lib/python3.10/site-packages -type d -name "tests" -exec rm -rf {} + 2>/dev/null || true && \
#     find /usr/local/lib/python3.10/site-packages -type d -name "test" -exec rm -rf {} + 2>/dev/null || true && \
#     find /usr/local/lib/python3.10/site-packages -name "*.pyi" -delete && \
#     find /usr/local/lib/python3.10/site-packages -name "*.md" -delete && \
#     find /usr/local -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true && \
#     find /usr/local -name "*.pyc" -delete

# # Copy compressed model
# COPY onnx-model.tar.gz .

# # Extract and remove archive in one layer
# RUN tar -xzf onnx-model.tar.gz && rm onnx-model.tar.gz

# COPY main.py app.py start.sh ./
# RUN chmod +x start.sh

# EXPOSE 8000 8501

# CMD ["./start.sh"]

# FROM python:3.10-slim

# WORKDIR /app

# # Install uv via pip (alternative to COPY from ghcr.io)
# RUN pip install --no-cache-dir uv 

# # Install base packages first
# RUN uv pip install --system --no-cache-dir \
#     fastapi==0.118.0 \
#     uvicorn==0.37.0 \
#     pillow==11.0.0 \
#     streamlit==1.50.0 \
#     numpy==2.1.2 \
#     requests & uv pip install torch==2.2.0+cpu torchvision==0.17.0+cpu --index-url https://download.pytorch.org/whl/cpu

# # Install ONNX Runtime
# RUN uv pip install --system --no-cache-dir onnxruntime==1.23.0 

# # Install transformer dependencies (BEFORE transformers to control versions)
# RUN uv pip install --system --no-cache-dir \
#     huggingface-hub \
#     tokenizers==0.21.0 \
#     safetensors \
#     regex \
#     tqdm \
#     packaging \
#     filelock \
#     pyyaml

# # Install transformers WITHOUT dependencies (prevents torch installation)
# RUN uv pip install --system --no-cache-dir --no-deps transformers==4.53.3

# # Install optimum WITHOUT dependencies (prevents torch installation)
# RUN uv pip install --system --no-cache-dir --no-deps optimum==1.16.0

# # Verify torch was NOT installed
# # RUN python3 -c "import importlib.util; import sys; sys.exit(1 if importlib.util.find_spec('torch') else 0)" && echo "ERROR: torch found!" || echo "SUCCESS: No torch"

# # Clean up
# RUN find /usr/local -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true && \
#     find /usr/local -name "*.pyc" -delete

# # Copy model
# COPY onnx-image-captioning-model-quantized.tar.gz .
# RUN tar -xzf onnx-image-captioning-model-quantized.tar.gz && rm onnx-image-captioning-model-quantized.tar.gz

# # Copy application files
# COPY main.py app.py start.sh ./
# RUN chmod +x start.sh

# EXPOSE 8000 8501

# CMD ["./start.sh"]