import os

import nltk
import requests
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
    nltk_data_sets = [
        "punkt",
        "wordnet",
        "averaged_perceptron_tagger",
        "stopwords",
    ]
    # Define the desired paths where the packages should exist
    desired_paths = [
        "/root/nltk_data",
        "/usr/local/nltk_data",
        "/usr/local/share/nltk_data",
        "/usr/local/lib/nltk_data",
        "/usr/share/nltk_data",
        "/usr/lib/nltk_data",
    ]

    print("Downloading and validating NLTK data sets...")
    for data_set in nltk_data_sets:
        try:
            # Attempt to find the data set to see if it's already downloaded
            nltk.data.find(f"tokenizers/{data_set}")
            print(f"{data_set} already downloaded.")
        except LookupError:
            # If the data set is not found, download it
            nltk.download(data_set)
            print(f"{data_set} downloaded successfully.")

        # Validate if the data set exists in the desired paths
        found = False
        for path in desired_paths:
            if os.path.exists(os.path.join(path, "tokenizers", data_set)):
                print(f"{data_set} exists in {path}")
                found = True
                break
        if not found:
            print(f"Warning: {data_set} not found in the desired paths after download.")


if __name__ == "__main__":
    # Hugging Face Transformers model
    download_transformers_model("microsoft/table-transformer-structure-recognition")

    # YOLOX model
    model_url = (
        "https://huggingface.co/unstructuredio/yolo_x_layout/blob/main/yolox_l0.05.onnx"
    )
    save_path = "/root/.cache/huggingface/hub/models--unstructuredio--yolo_x_layout/yolox_l0.05.onnx"
    download_file_from_url(model_url, save_path)

    # TIMM model
    download_timm_model("resnet18.a1_in1k")

    # NLTK data
    download_nltk_data()
