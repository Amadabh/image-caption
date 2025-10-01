#!/bin/bash

# Start FastAPI in background
uvicorn main:app --host 0.0.0.0 --port 8000 &

# Start Streamlit in foreground
streamlit run app.py --server.port 8501 --server.address 0.0.0.0