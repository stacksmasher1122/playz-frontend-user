import os
import re

directory = r"f:\playz\playz-frontend-user\redesign\lib\view\USER\Tournament\create_tournament\widgets"
for filename in os.listdir(directory):
    if not filename.endswith(".dart"):
        continue
    filepath = os.path.join(directory, filename)
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    
    # Fix widget.namedParam: widget.namedParam -> namedParam: widget.namedParam
    new_content = re.sub(r'widget\.(\w+)\s*:\s*widget\.\1', r'\1: widget.\1', content)
    
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(new_content)

# Also fix the _CreateTournamentContent in create_tournament_screen.dart
filepath = r"f:\playz\playz-frontend-user\redesign\lib\view\USER\Tournament\create_tournament\create_tournament_screen.dart"
with open(filepath, "r", encoding="utf-8") as f:
    content = f.read()
new_content = re.sub(r'widget\.(\w+)\s*:\s*widget\.\1', r'\1: widget.\1', content)
with open(filepath, "w", encoding="utf-8") as f:
    f.write(new_content)
