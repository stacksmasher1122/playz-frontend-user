import os
import re

volleyball_dir = r"f:\playz\playz-frontend-user\redesign\lib\view\USER\Home\Scoreboard\Volleyball"

# Regex to match actions: [...] in the AppBar containing account_circle
actions_pattern = re.compile(r"actions:\s*\[[^\]]*?account_circle[^\]]*?\]\s*,", re.DOTALL)
# Or if it's just a row of icons without actions:
icon_pattern = re.compile(r"Icon\(Icons\.account_circle.*?,\s*")
icon_button_pattern = re.compile(r"IconButton\(\s*icon:\s*Icon\(Icons\.account_circle.*?\),\s*onPressed:\s*\(\)\s*\{\},\s*\),?", re.DOTALL)

for root, dirs, files in os.walk(volleyball_dir):
    for file in files:
        if file.endswith('.dart'):
            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            original = content
            
            # If the entire actions block just has the account circle, remove the actions block
            if "actions:" in content and "account_circle" in content:
                content = actions_pattern.sub("", content)
            
            # Otherwise, just strip the IconButton or Icon if it's floating
            if "account_circle" in content:
                content = icon_button_pattern.sub("", content)
                content = icon_pattern.sub("", content)
                
            if content != original:
                with open(path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"Removed profile icon from {file}")
