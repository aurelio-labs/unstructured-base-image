import os
import requests
import nltk
import timm
from transformers import AutoModel


def download_file_from_url(url, save_path):
    """Download a file from a specified URL to a specified save path."""
    os.makedirs(os.path.dirname(save_path), exist_ok=True)
    response = requests.get(url, stream=True)
    if response.status_code == 200:
        with open(save_path, "wb") as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        print(f"File downloaded and saved to {save_path}.")
    else:
        print(f"Failed to download file. Status code: {response.status_code}")


def download_transformers_model(model_name):
    print(f"Downloading and caching {model_name} from Hugging Face Transformers...")
    model = AutoModel.from_pretrained(model_name)
    print(f"Model {model_name} downloaded and cached successfully.")


def download_timm_model(model_name):
    print(f"Downloading and caching {model_name} from TIMM...")
    model = timm.create_model(model_name, pretrained=True)
    print(f"Model {model_name} downloaded and cached successfully.")


def download_nltk_data():
    nltk_data_sets = ["punkt", "wordnet", "averaged_perceptron_tagger", "stopwords"]
    print("Downloading NLTK data sets...")
    for data_set in nltk_data_sets:
        nltk.download(data_set)
    print("NLTK data sets downloaded and cached successfully.")


if __name__ == "__main__":
    # Hugging Face Transformers model
    download_transformers_model("microsoft/table-transformer-structure-recognition")

    # YOLOX model
    model_url = "https://huggingface.co/unstructuredio/yolo_x_layout/blob/main/yolox_l0.05.onnx"
    save_path = "/root/.cache/huggingface/hub/models--unstructuredio--yolo_x_layout/yolox_l0.05.onnx"
    download_file_from_url(model_url, save_path)

    # TIMM model
    download_timm_model("resnet18.a1_in1k")

    # NLTK data
    download_nltk_data()
