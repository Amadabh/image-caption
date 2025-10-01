import streamlit as st
import requests
from PIL import Image
import io

st.set_page_config(page_title="Image Caption Generator", page_icon="🖼️", layout="centered")

st.title("🖼️ Image Captioning App")
st.write("Upload an image and get AI-generated captions!")

uploaded_file = st.file_uploader("Choose an Image", type=["png", "jpg", "jpeg"])
if uploaded_file is not None:
    image = Image.open(uploaded_file)

    st.image(image, caption="Uploaded Image", use_container_width=True)
    if st.button("Generate Caption"):
        with st.spinner("Generating caption.."):
            files = {"file": uploaded_file.getvalue()}
            response = requests.post("http://localhost:8000/upload", files=files)
            if response.status_code == 200:
                captions = response.json()["captions"]
                
                
                st.success("Caption generated successfully!")
                for i, caption in enumerate(captions):
                    st.write(f"Caption {i + 1}: {caption}")
            else:
                st.error("Error generating caption.")