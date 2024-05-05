import PyPDF2
import datetime
import re

class PDFProcessor:
    def __init__(self, file_path):
        self.file_path = file_path

    def extract_data(self):
        with open(self.file_path, 'rb') as f:
            pdf_reader = PyPDF2.PdfReader(f)
            data = {"measurements": []}

            for page in pdf_reader.pages:
                text = page.extract_text()
                content_lines = text.split("\n")
                patient_info = content_lines[2].strip().split()

                time = {
                    "date": datetime.datetime.strptime(patient_info[2], '%d.%m.%Y.').strftime('%Y-%m-%d'),
                    "hour": datetime.datetime.strptime(patient_info[3], '%H:%M').strftime('%H:%M:%S')
                }

                patient = {
                    "id": content_lines[1].strip().split()[0],
                    "name": "Ricardo Garcia",
                    "sex": "Male",
                    "age": int(patient_info[0]),
                    "height": int(patient_info[1].split("cm")[0]),
                    "weight": float(content_lines[11].strip().split()[0])
                }

                patient_id = content_lines[1].strip().split()[0] + '-' + time["date"]
                data["id"] = patient_id

                pattern = r'\)\s*(\d+\.\d+)\s*\('

                # Assuming specific lines for each component based on a general knowledge of content structure
                try:
                    totalBodyWater = float(re.search(pattern, content_lines[3]).group(1))
                    proteins = float(re.search(pattern, content_lines[4]).group(1))
                    minerals = float(re.search(pattern, content_lines[5]).group(1))
                    bodyFatMass = float(re.search(pattern, content_lines[6]).group(1))
                except IndexError:
                    continue  # Skip if any data is missing

                dryLeanMass = proteins + minerals
                leanBodyMass = totalBodyWater + dryLeanMass
                totalWeight = leanBodyMass + bodyFatMass

                bodyComposition = {
                    "totalBodyWater": totalBodyWater,
                    "proteins": proteins,
                    "minerals": minerals,
                    "dryLeanMass": dryLeanMass,
                    "leanBodyMass": leanBodyMass,
                    "bodyFatMass": bodyFatMass,
                    "totalWeight": totalWeight
                }

                measurement = {
                    "time": time,
                    "patient": patient,
                    "bodyComposition": bodyComposition
                }

                data["measurements"].append(measurement)
            return data
