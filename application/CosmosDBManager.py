from azure.cosmos import CosmosClient, PartitionKey

class CosmosDBManager:
    def __init__(self, cosmosdb_endpoint, cosmosdb_key, database_id, container_id):
        self.client = CosmosClient(cosmosdb_endpoint, credential=cosmosdb_key)
        self.database = self.client.get_database_client(database_id)
        self.container = self.database.get_container_client(container_id)

    def round_values(self, data):
        if isinstance(data, float):
            return round(data, 2)
        elif isinstance(data, dict):
            return {key: self.round_values(value) for key, value in data.items()}
        elif isinstance(data, list):
            return [self.round_values(item) for item in data]
        else:
            return data

    def create_item(self, item):
        rounded_item = self.round_values(item)
        self.container.create_item(body=rounded_item)

    def read_item(self, item_id):
        item = self.container.read_item(item_id=item_id, partition_key=item_id)
        return item

    def update_item(self, item_id, updated_item):
        current_item = self.read_item(item_id)
        if current_item:
            rounded_updated_item = self.round_values(updated_item)
            self.container.upsert_item(body=rounded_updated_item)
            return True
        else:
            return False

    def delete_item(self, item_id):
        current_item = self.read_item(item_id)
        if current_item:
            self.container.delete_item(item=current_item, partition_key=item_id)
            return True
        else:
            return False
