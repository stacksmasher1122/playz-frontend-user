import os
import re

directories = [
    r"f:\playz\playz-frontend-user\redesign\lib\controller\User_Controller\Home_Controller\Scoreboard_Controller",
]

# Match 'const ' followed by an uppercase letter, or an underscore + uppercase letter (private widgets), or '['
pattern = re.compile(r'const\s+([A-Z]|_[A-Z]|\[)')

def remove_const(filepath):
    if not filepath.endswith('.dart'):
        return
        
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    new_content = pattern.sub(r'\1', content)

    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Removed consts from {filepath}")

for path in directories:
    if os.path.isfile(path):
        remove_const(path)
    elif os.path.isdir(path):
        for root, _, files in os.walk(path):
            for file in files:
                remove_const(os.path.join(root, file))

print("Done removing consts.")
