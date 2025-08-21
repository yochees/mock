#!/bin/zsh
cd "$(dirname "$0")" 

# Ask user for number of loops
echo -n "How many loops do you want to run? "
read num_loops

# Validate input
if ! [[ "$num_loops" =~ ^[0-9]+$ ]] || [ "$num_loops" -le 0 ]; then
    echo "Error: Please enter a positive number"
    exit 1
fi

echo

# Show file selection once
echo "Select prompt file for all loops:"
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

echo
echo "Will use: $(basename "$selected_file") for all $num_loops loops"
echo "Running $num_loops loops..."
echo

# Execute gen.command for the specified number of times
for i in $(seq 1 $num_loops); do
    echo "=== Loop $i of $num_loops ==="
    ./gen.command $i "$selected_file"
    echo
done

echo "All loops completed!"
