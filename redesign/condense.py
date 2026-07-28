import os
import re

input_path = r"c:\Users\Aditya\.gemini\antigravity-ide\brain\4fdc4755-8c05-4a79-9237-c525ba581983\massive_2000_line_prompt.md"
output_path = r"c:\Users\Aditya\.gemini\antigravity-ide\brain\4fdc4755-8c05-4a79-9237-c525ba581983\condensed_14500_prompt.md"
master_path = r"c:\Users\Aditya\.gemini\antigravity-ide\brain\4fdc4755-8c05-4a79-9237-c525ba581983\master_code_architecture_prompt.md"

# Load the comprehensive architecture summary if available
master_content = ""
if os.path.exists(master_path):
    with open(master_path, 'r', encoding='utf-8') as f:
        master_content = f.read()
else:
    master_content = "You are an expert Flutter Developer. Below is the architecture of PlayZ:\n"

# Load the massive file
with open(input_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Parse the massive file into separate files
files = re.split(r'--- File: .*? ---', content)
headers = re.findall(r'--- File: .*? ---', content)

# Prioritize important files (main.dart, a controller, a ui file)
important_files = [
    "main.dart",
    "registerController.dart",
    "home_screen.dart",
    "maps_controller.dart"
]

final_text = master_content + "\n\n### CORE CODE SNIPPETS ###\n\n"
target_length = 14450 # Leave room for the ending

# First, add prioritized files
added_indices = set()
for important_file in important_files:
    for i in range(len(headers)):
        if important_file in headers[i] and i not in added_indices:
            file_text = headers[i] + files[i+1]
            if len(final_text) + len(file_text) <= target_length:
                final_text += file_text
                added_indices.add(i)
            else:
                remaining = target_length - len(final_text)
                if remaining > 100:
                    final_text += file_text[:remaining] + "\n...[TRUNCATED]"
                added_indices.add(i)
            break

# If we still have room, add other files
for i in range(len(headers)):
    if i not in added_indices:
        file_text = headers[i] + files[i+1]
        if len(final_text) + len(file_text) <= target_length:
            final_text += file_text
            added_indices.add(i)
        else:
            remaining = target_length - len(final_text)
            if remaining > 100:
                final_text += file_text[:remaining] + "\n...[TRUNCATED]"
            break

# Pad to exactly 14500 characters if it's too short (though it should be right at the limit)
final_text += "\n\nEnd of context."

if len(final_text) < 14500:
    padding_needed = 14500 - len(final_text)
    final_text += " " * padding_needed
elif len(final_text) > 14500:
    final_text = final_text[:14500]

with open(output_path, 'w', encoding='utf-8') as f:
    f.write(final_text)

print(f"Created condensed file. Final length: {len(final_text)} characters.")
