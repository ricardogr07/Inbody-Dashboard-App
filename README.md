# Inbody Dashboard App
 Inbody Dashboard App

What I want to do is the following:
1. Upload pdf into blob storage
2. Trigger Azure Function to process pdf into json information
3. Pass json to a second Azure Function, use key vault to get cosmos db information, and upsert entry of the json file to cosmos db
4. Have an HTTP trigger Azure Function that uses keyvault to get cosmos db information, and reads everything there is in cosmos db for a given user, then returns back all those json files
5. Have another Azure Function that takes as input the json files from the previous function, and analyzes them, creating a df with information
6. Last Azure Function gives back the csv clean information that will be used in Power BI