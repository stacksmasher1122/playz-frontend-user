import re
import os

with open('analyze_output_utf8.txt', 'r', encoding='utf-8') as f:
    lines = f.readlines()

errors = []
for line in lines:
    if 'error' in line and 'const_eval_method_invocation' in line:
        parts = line.split(' - ')
        if len(parts) >= 3:
            file_loc = parts[1].strip() # The path is the second part
            # file_loc format: Tennis\...\file.dart:82:67
            loc_parts = file_loc.split(':')
            if len(loc_parts) >= 3:
                filepath = file_loc.rsplit(':', 2)[0]
                line_num = int(loc_parts[-2])
                col_num = int(loc_parts[-1])
                full_path = os.path.join(r'f:\playz\playz-frontend-user\redesign\lib\view\USER\Home\Scoreboard', filepath)
                errors.append((full_path, line_num, col_num))

files_to_fix = {}
for err in errors:
    filepath, line_num, col_num = err
    if filepath not in files_to_fix:
        files_to_fix[filepath] = []
    files_to_fix[filepath].append(line_num)

for filepath, line_nums in files_to_fix.items():
    print(f"Fixing {filepath}...")
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content_lines = f.readlines()
    except Exception as e:
        print(f"Failed to open {filepath}: {e}")
        continue
    
    line_nums = sorted(list(set(line_nums)), reverse=True)
    
    for l_num in line_nums:
        idx = l_num - 1
        if 0 <= idx < len(content_lines):
            line_content = content_lines[idx]
            if 'const ' in line_content:
                content_lines[idx] = line_content.replace('const ', '')
                print(f"  Removed const on line {l_num}")
            else:
                for back in range(1, 4):
                    if idx - back >= 0 and 'const ' in content_lines[idx - back]:
                        content_lines[idx - back] = content_lines[idx - back].replace('const ', '')
                        print(f"  Removed const on line {l_num - back}")
                        break

    with open(filepath, 'w', encoding='utf-8') as f:
        f.writelines(content_lines)

print("Done fixing const errors.")
