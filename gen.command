#!/bin/zsh

# Change to script directory
cd "$(dirname "$0")"

# Check if file was passed as argument (for loop mode)
if [ "$2" != "" ]; then
    selected_file="$2"
    echo "Using pre-selected file: $(basename "$selected_file")"
else
    # Interactive mode - show file selection
    echo "Available prompt files:"
    echo "======================"
    files=(prompts/*.*.txt)
    i=1
    for file in "${files[@]}"; do
        filename=$(basename "$file")
        echo "$i. $filename"
        ((i++))
    done
    echo

    # Get user choice
    echo "Choose a prompt file:"
    echo "- Enter a number (1-${#files[@]}), or"
    echo "- Type the filename (e.g., data.csv.txt)"
    echo -n "Choice: "
    read choice

    # Determine selected file
    selected_file=""
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#files[@]}" ]; then
        # User entered a valid number
        selected_file="${files[$choice]}"
    elif [[ -f "prompts/$choice" ]]; then
        # User entered a filename that exists
        selected_file="prompts/$choice"
    else
        echo "Error: Invalid choice '$choice'"
        exit 1
    fi
fi

echo "Using: $(basename "$selected_file")"
echo

# Generate output filename from double extension format
input_filename=$(basename "$selected_file")
# Extract format from second-to-last extension (e.g., csv.txt -> csv)
output_format="${input_filename%.*}"  # Remove .txt
output_format="${output_format##*.}"  # Get last part (the format)
# Create base filename without the double extension
base_name="${input_filename%.*.*}"    # Remove .format.txt
base_output_filename="${base_name}.${output_format}"

# Check if loop number was passed as argument
if [ "$1" != "" ]; then
    # Add loop number to filename: data.csv -> data-1.csv
    filename_without_ext="${base_output_filename%.*}"
    extension="${base_output_filename##*.}"
    output_filename="${filename_without_ext}-$1.${extension}"
else
    output_filename="$base_output_filename"
fi

echo "Output will be saved as: $output_filename"
echo

# Run llm command with selected file
llm < "$selected_file" > "$output_filename"
