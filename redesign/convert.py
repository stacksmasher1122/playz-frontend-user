import os
import re

directory = r"f:\playz\playz-frontend-user\redesign\lib\view\USER\Tournament\create_tournament\widgets"

for filename in os.listdir(directory):
    if not filename.endswith(".dart"):
        continue
    filepath = os.path.join(directory, filename)
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    
    if "extends StatelessWidget" not in content:
        continue
        
    # Find class name
    class_match = re.search(r'class\s+(\w+)\s+extends\s+StatelessWidget', content)
    if not class_match:
        continue
    class_name = class_match.group(1)
    
    # Extract properties to know what to prefix with `widget.`
    props_match = re.findall(r'final\s+(?:[\w<>?]+)\s+(\w+);', content)
    props = [p for p in props_match if p != 'key']
    
    # We also need to catch Function types like `final VoidCallback onTap;` or `final Function(String) onSportSelected;`
    # Let's just catch all lines with `final `
    all_finals = re.findall(r'final\s+.*?\s+(\w+);', content)
    
    # Split content at `@override\n  Widget build(BuildContext context) {`
    parts = re.split(r'@override\s*Widget build\(BuildContext context\) {', content)
    if len(parts) < 2:
        parts = re.split(r'@override\s*Widget build\(BuildContext context\) =>', content)
        if len(parts) < 2:
            print(f"Skipping {filename} due to build method regex failure")
            continue
        build_body = "=>" + parts[1]
    else:
        build_body = "{" + parts[1]
        
    top_part = parts[0].replace(f"class {class_name} extends StatelessWidget", f"class {class_name} extends StatefulWidget")
    
    # Add state class creation
    top_part += f"\n  @override\n  State<{class_name}> createState() => _{class_name}State();\n}}\n\nclass _{class_name}State extends State<{class_name}> {{\n  @override\n  Widget build(BuildContext context) "
    
    # Replace variable usages in build_body with widget.var
    for prop in all_finals:
        # Match prop as a whole word
        build_body = re.sub(rf'\b{prop}\b', f'widget.{prop}', build_body)
        
    new_content = top_part + build_body
    
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(new_content)
    print(f"Converted {filename}")

# Also do the skeleton and main screen inner classes if they are stateless
directory2 = r"f:\playz\playz-frontend-user\redesign\lib\view\USER\Tournament\create_tournament"
for filename in os.listdir(directory2):
    if not filename.endswith(".dart"):
        continue
    filepath = os.path.join(directory2, filename)
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    
    # _CreateTournamentContent in create_tournament_screen.dart
    if "class _CreateTournamentContent extends StatelessWidget" in content:
        class_name = "_CreateTournamentContent"
        all_finals = re.findall(r'final\s+.*?\s+(\w+);', content)
        # Only replace finals that belong to this class
        my_finals = ["controller", "formKey", "nameController", "descriptionController"]
        parts = re.split(r'@override\s*Widget build\(BuildContext context\) {', content)
        top_part = parts[0].replace(f"class {class_name} extends StatelessWidget", f"class {class_name} extends StatefulWidget")
        top_part += f"\n  @override\n  State<{class_name}> createState() => _{class_name}State();\n}}\n\nclass _{class_name}State extends State<{class_name}> {{\n  @override\n  Widget build(BuildContext context) {{"
        build_body = parts[1]
        for prop in my_finals:
            build_body = re.sub(rf'\b{prop}\b', f'widget.{prop}', build_body)
        content = top_part + build_body
        with open(filepath, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"Converted _CreateTournamentContent in {filename}")
        
    elif "extends StatelessWidget" in content and filename == "create_tournament_skeleton.dart":
        # Skeleton has CreateTournamentSkeleton, _SkeletonBox, _SkeletonCircle, _SkeletonText
        classes = ["CreateTournamentSkeleton", "_SkeletonBox", "_SkeletonCircle", "_SkeletonText"]
        for c in classes:
            if f"class {c} extends StatelessWidget" in content:
                # This is tricky to regex multiple classes in one file.
                pass

