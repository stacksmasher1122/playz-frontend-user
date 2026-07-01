import os
import re

directories = [
    r"f:\playz\playz-frontend-user\redesign\lib\view\USER\Book",
]

responsive_import = "import 'package:redesign/theme/responsive_helper.dart';\n"
init_pattern = r"Widget build\(BuildContext context\) \{"
init_replacement = r"Widget build(BuildContext context) {\n    ResponsiveHelper.init(context);"

patterns = [
    # width: 10, -> width: ResponsiveHelper.w(10),
    (re.compile(r"width:\s*([0-9]+\.?[0-9]*)\s*([,}])"), r"width: ResponsiveHelper.w(\1)\2"),
    # height: 10, -> height: ResponsiveHelper.h(10),
    (re.compile(r"height:\s*([0-9]+\.?[0-9]*)\s*([,}])"), r"height: ResponsiveHelper.h(\1)\2"),
    # fontSize: 10, -> fontSize: ResponsiveHelper.sp(10),
    (re.compile(r"fontSize:\s*([0-9]+\.?[0-9]*)\s*([,}])"), r"fontSize: ResponsiveHelper.sp(\1)\2"),
    # EdgeInsets.all(10) -> EdgeInsets.all(ResponsiveHelper.w(10))
    (re.compile(r"EdgeInsets\.all\(\s*([0-9]+\.?[0-9]*)\s*\)"), r"EdgeInsets.all(ResponsiveHelper.w(\1))"),
    # EdgeInsets.symmetric(horizontal: 10, vertical: 20)
    (re.compile(r"EdgeInsets\.symmetric\(\s*horizontal:\s*([0-9]+\.?[0-9]*)\s*,\s*vertical:\s*([0-9]+\.?[0-9]*)\s*\)"), r"EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(\1), vertical: ResponsiveHelper.h(\2))"),
    (re.compile(r"EdgeInsets\.symmetric\(\s*vertical:\s*([0-9]+\.?[0-9]*)\s*,\s*horizontal:\s*([0-9]+\.?[0-9]*)\s*\)"), r"EdgeInsets.symmetric(vertical: ResponsiveHelper.h(\1), horizontal: ResponsiveHelper.w(\2))"),
    # EdgeInsets.symmetric(horizontal: 10)
    (re.compile(r"EdgeInsets\.symmetric\(\s*horizontal:\s*([0-9]+\.?[0-9]*)\s*\)"), r"EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(\1))"),
    # EdgeInsets.symmetric(vertical: 10)
    (re.compile(r"EdgeInsets\.symmetric\(\s*vertical:\s*([0-9]+\.?[0-9]*)\s*\)"), r"EdgeInsets.symmetric(vertical: ResponsiveHelper.h(\1))"),
    # EdgeInsets.only(...)
    (re.compile(r"left:\s*([0-9]+\.?[0-9]*)\s*([,}])"), r"left: ResponsiveHelper.w(\1)\2"),
    (re.compile(r"right:\s*([0-9]+\.?[0-9]*)\s*([,}])"), r"right: ResponsiveHelper.w(\1)\2"),
    (re.compile(r"top:\s*([0-9]+\.?[0-9]*)\s*([,}])"), r"top: ResponsiveHelper.h(\1)\2"),
    (re.compile(r"bottom:\s*([0-9]+\.?[0-9]*)\s*([,}])"), r"bottom: ResponsiveHelper.h(\1)\2"),
    # BorderRadius.circular(10)
    (re.compile(r"BorderRadius\.circular\(\s*([0-9]+\.?[0-9]*)\s*\)"), r"BorderRadius.circular(ResponsiveHelper.w(\1))"),
    # Radius.circular(10)
    (re.compile(r"Radius\.circular\(\s*([0-9]+\.?[0-9]*)\s*\)"), r"Radius.circular(ResponsiveHelper.w(\1))"),
]

def process_file(filepath):
    if not filepath.endswith(".dart"):
        return
        
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Skip if already imported or if it doesn't have a build method
    if "ResponsiveHelper" in content:
        return
    if "Widget build(BuildContext context) {" not in content:
        return

    # Add import
    lines = content.split('\n')
    import_idx = 0
    for i, line in enumerate(lines):
        if line.startswith("import "):
            import_idx = i
    
    lines.insert(import_idx + 1, responsive_import.strip())
    content = '\n'.join(lines)

    # Init helper
    content = re.sub(init_pattern, init_replacement, content)

    # Replace values
    for pattern, repl in patterns:
        content = pattern.sub(repl, content)

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

for path in directories:
    if os.path.isfile(path):
        process_file(path)
    elif os.path.isdir(path):
        for root, _, files in os.walk(path):
            for file in files:
                process_file(os.path.join(root, file))

print("Done refactoring responsive helpers.")
