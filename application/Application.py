import argparse
import os
import pandas as pd
from PDFProcessor import PDFProcessor
from CosmosDBManager import CosmosDBManager
from DataStore import DataStore
import plotly.express as px
import matplotlib.pyplot as plt

class Application:
    def __init__(self, directory, json_directory=None, cosmosdb_endpoint=None, cosmosdb_key=None, database_id=None, container_id=None):
        self.directory = directory
        self.json_directory = json_directory or directory
        self.cosmos_manager = None

        if cosmosdb_endpoint and cosmosdb_key and database_id and container_id:
            self.cosmos_manager = CosmosDBManager(cosmosdb_endpoint, cosmosdb_key, database_id, container_id)

    def run(self):
        dfs = []
        for file_name in os.listdir(self.directory):
            if file_name.endswith(".pdf") and "Inbody" in file_name:
                pdf_processor = PDFProcessor(os.path.join(self.directory, file_name))
                data = pdf_processor.extract_data()

                df = pd.json_normalize(data['measurements'])
                df['bodyComposition.bodyFatPercentage'] = (df['bodyComposition.bodyFatMass'] / df['bodyComposition.totalWeight']) * 100
                dfs.append(df)

                if self.cosmos_manager:
                    self.cosmos_manager.update_item(data)
                    print(f"Processed and uploaded to Cosmos DB: {file_name}")
                else:
                    json_path = os.path.join(self.json_directory, os.path.splitext(file_name)[0] + ".json")
                    data_store = DataStore(json_path)
                    data_store.save_data(data)
                    print(f"Processed and saved locally: {json_path}")

        if dfs:
            combined_df = pd.concat(dfs, ignore_index=True)
            print(combined_df)
            self.plot_interactive_weight(combined_df)
            input("Press Enter to continue...")

    def plot_interactive_weight(self, df):
        df['time.date'] = pd.to_datetime(df['time.date'])
        fig = px.line(df, x='time.date', y='bodyComposition.totalWeight',
                      text='bodyComposition.bodyFatMass',
                      hover_data={'bodyFatMass (kg)': df['bodyComposition.bodyFatMass'],
                                  'Body Fat Percentage (%)': df['bodyComposition.bodyFatPercentage'].round(2)},
                      title='Interactive Plot of Total Body Weight')
        fig.update_traces(textposition="bottom right")
        fig.update_layout(hovermode='x')
        fig.show()
    def plot_weight(self, df):
        df['time.date'] = pd.to_datetime(df['time.date'])  # Convert the date column to datetime format

        plt.figure(figsize=(10, 6))  # Set the figure size

        # Create the primary axis
        ax1 = plt.gca()  # Get current axis
        ax1.plot(df['time.date'], df['bodyComposition.totalWeight'], label='Total Body Weight (kg)', marker='o', linestyle='-', color='blue')
        ax1.plot(df['time.date'], df['bodyComposition.bodyFatMass'], label='Body Fat Mass (kg)', marker='x', linestyle='--', color='red')
        ax1.set_title('Total Body Weight, Body Fat Mass, and Body Fat Percentage Over Time')
        ax1.set_xlabel('Date')
        ax1.set_ylabel('Weight (kg)')
        ax1.legend(loc='upper left')
        ax1.grid(True)
        ax1.set_xticklabels(df['time.date'], rotation=45)

        # Create the secondary axis
        ax2 = ax1.twinx()  # Create a second y-axis sharing the same x-axis
        ax2.plot(df['time.date'], df['bodyComposition.bodyFatPercentage'], label='Body Fat Percentage (%)', marker='s', linestyle=':', color='green')
        ax2.set_ylabel('Percentage (%)')
        ax2.legend(loc='upper right')

        plt.tight_layout()  # Adjust layout
        plt.show()  # Display the plot

if __name__ == "__main__":
    
    parser = argparse.ArgumentParser(description="Process PDF files and optionally upload to Cosmos DB or save locally.")
    parser.add_argument("directory", type=str, help="Directory containing PDF files to process.")
    parser.add_argument("--json_directory", type=str, help="Directory to save JSON files if Cosmos DB is not connected.")
    parser.add_argument("--cosmosdb_endpoint", type=str, help="Cosmos DB endpoint URL.")
    parser.add_argument("--cosmosdb_key", type=str, help="Cosmos DB key.")
    parser.add_argument("--database_id", type=str, help="Cosmos DB database ID.")
    parser.add_argument("--container_id", type=str, help="Cosmos DB container ID.")

    args = parser.parse_args()
    app = Application(args.directory, args.json_directory, args.cosmosdb_endpoint, args.cosmosdb_key, args.database_id, args.container_id)
    app.run()
