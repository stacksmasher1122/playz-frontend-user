import os
import re

volleyball_dir = r"f:\playz\playz-frontend-user\redesign\lib\view\USER\Home\Scoreboard\Volleyball"
files_updated = 0

# Regex patterns
# Match AppColors.card.withValues(alpha: 0.8) or 0.85 etc.
card_alpha_pattern = re.compile(r"AppColors\.card\.withValues\(alpha:\s*0\.\d+\)")
# Match Border.all(color: AppColors.outlineVariant) or with alpha
border_pattern = re.compile(r"Border\.all\(\s*color:\s*AppColors\.outlineVariant(?:.*?)\)")

for root, dirs, files in os.walk(volleyball_dir):
    for file in files:
        if file.endswith('.dart'):
            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            original_content = content
            
            content = card_alpha_pattern.sub("AppColors.card", content)
            content = border_pattern.sub("Border.all(color: Colors.transparent)", content)
            
            if content != original_content:
                with open(path, 'w', encoding='utf-8') as f:
                    f.write(content)
                files_updated += 1

print(f"Flattened theme in {files_updated} files!")
