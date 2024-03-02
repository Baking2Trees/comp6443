#!/bin/bash

# Prompt for user input
read -r -p "Enter the first filename: " file_a
read -r -p "Enter the second filename: " file_b
read -r -p "Enter the delimiter: " delimiter

# Construct the output filename
output_name="combined_$(basename "$file_a" .txt)_AND_$(basename "$file_b" .txt)_with_${delimiter}_wordlists.txt"

# Check if both input files exist
if [ ! -f "$file_a" ] || [ ! -f "$file_b" ]; then
    echo "One or both input files not found!"
    exit 1
fi

# Create a temporary file to store intermediate results
temp_file=$(mktemp)

# Generate all combinations of words with the specified delimiter
awk -v delim="$delimiter" 'NR==FNR {a[$0]; next} {for (i in a) print $0 delim i}' "$file_b" "$file_a" > "$temp_file"
awk -v delim="$delimiter" 'NR==FNR {a[$0]; next} {for (i in a) print $0 delim i}' "$file_a" "$file_b" >> "$temp_file"

# Sort and remove duplicates
sort -u "$temp_file" > "$output_name"

# Cleanup temporary file
rm "$temp_file"

echo "Combined wordlists saved in $output_name"