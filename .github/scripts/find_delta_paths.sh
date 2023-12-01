#!/bin/bash

adminapi_paths=$(jq '.paths' adminapi.json)
swag_paths=$(jq '.paths' $1-adminapi.json)

adminapi_keys=$(echo "$adminapi_paths" | jq 'keys[]')
swag_keys=$(echo "$swag_paths" | jq 'keys[]')

result_json=$(jq '.' $1-adminapi.json)

for key in $swag_keys
do
  # Check if key is in adminapi keys
  if [[ "$adminapi_keys" == *"$key"* ]]; then
    # Remove leading and trailing quotes from key
    key="${key%\"}"
    key="${key#\"}"

    result_json=$(echo "$result_json" | jq "del(.paths.\"$key\")")
  fi
done

echo "$result_json" > $1-adminapi.json
