import re
import os

# Define the input and output directories
md_file = "./README.md"  # Path to your markdown file
output_dir = "python_programs"  # Directory to save the .py files

# Ensure the output directory exists
os.makedirs(output_dir, exist_ok=True)

# Read the markdown file
with open(md_file, "r") as file:
    md_content = file.read()

# Regular expression to match Python code blocks
pattern = re.compile(r"```python\n(.*?)\n```", re.DOTALL)

# Find all matches
matches = pattern.findall(md_content)

# Save each Python program into a separate .py file
# print(matches)
for i, program in enumerate(matches, 1):
    filename = f"{output_dir}/program_{i}.py"
    with open(filename, "w") as f:
        f.write(program.strip())  # Remove leading/trailing whitespace

    print(f"Saved program {i} to {filename}")
