#!/bin/bash

# Creating tables
for table_data in $(cat tables.json | jq -c '.[]'); do
  table_name=$(echo $table_data | jq -r '.TableName')
  attribute_definitions=$(echo $table_data | jq -c '.AttributeDefinitions[]')
  key_schema=$(echo $table_data | jq -c '.KeySchema[]')
  provisioned_throughput=$(echo $table_data | jq -c '.ProvisionedThroughput')
  awslocal dynamodb create-table \
    --table-name $table_name \
    --attribute-definitions "$attribute_definitions" \
    --key-schema "$key_schema" \
    --provisioned-throughput "$provisioned_throughput"
done

# Inserting items in models table
for models_item_data in $(cat data-table-models.json | jq -c '.[]'); do
  table_name=models
  awslocal dynamodb put-item \
    --table-name $table_name \
    --item "$models_item_data"
done