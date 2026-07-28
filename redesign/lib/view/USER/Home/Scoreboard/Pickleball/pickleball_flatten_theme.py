import os
import re

pickleball_dir = r'f:\playz\playz-frontend-user\redesign\lib\view\USER\Home\Scoreboard\Pickleball'
files_updated = 0

card_alpha_pattern = re.compile(r'AppColors\.card\.withValues\(alpha:\s*0\.\d+\)')
bg_alpha_pattern = re.compile(r'AppColors\.background\.withValues\(alpha:\s*0\.\d+\)')
border_pattern = re.compile(r'Border\.all\(\s*color:\s*AppColors\.outlineVariant(?:.*?)\)')
white_pattern = re.compile(r'Colors\.white')

excluded_files = ['heatmap_widget.dart', 'momentum_chart_widget.dart']

for root, dirs, files in os.walk(pickleball_dir):
    for file in files:
        if file.endswith('.dart'):
            if file in excluded_files:
                print(f'Skipping {file}')
                continue
                
            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            original_content = content
            
            content = card_alpha_pattern.sub('AppColors.card', content)
            content = bg_alpha_pattern.sub('AppColors.background', content)
            content = border_pattern.sub('Border.all(color: Colors.transparent)', content)
            content = white_pattern.sub('AppColors.textPrimary', content)
            
            if content != original_content:
                if 'import ''package:redesign/theme/app_colors.dart''' not in content:
                    content = 'import ''package:redesign/theme/app_colors.dart'';\n' + content
                with open(path, 'w', encoding='utf-8') as f:
                    f.write(content)
                files_updated += 1
                print(f'Updated {file}')

print(f'\nFlattened theme in {files_updated} files!')
