import nltk
import timm
from transformers import AutoModel

def download_transformers_model(model_name):
    print(f"Downloading and caching {model_name} from Hugging Face Transformers...")
    model = AutoModel.from_pretrained(model_name)
    # Initialize the UnstructuredTableTransformerModel with the downloaded model
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
    transformers_model_name = "microsoft/table-transformer-structure-recognition"
    download_transformers_model(transformers_model_name)

    # TIMM model
    timm_model_name = "resnet18.a1_in1k"
    download_timm_model(timm_model_name)

    # NLTK data
    download_nltk_data()