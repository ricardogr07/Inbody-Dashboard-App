import json

class DataStore:
    def __init__(self, file_path):
        self.file_path = file_path

    def save_data(self, data):
        with open(self.file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=4)

    def load_data(self):
        with open(self.file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
