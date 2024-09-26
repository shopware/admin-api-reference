#!/bin/bash
set -e

# Input file containing the OpenAPI schema
input_file=$1

# Output file
output_file=$2

# Extract keys from "paths" and "components.schemas"
paths=$(jq '.paths | keys' "$input_file")
schemas=$(jq '.components.schemas | keys' "$input_file")

# Prepare output JSON
output_json="{ \"paths\": $paths, \"schemas\": $schemas }"

# Pretty-print and save the output JSON to a file
echo "$output_json" | jq '.' > "$output_file"

echo "Extracted keys from 'paths' and 'components.schemas' and saved to '$output_file'."
