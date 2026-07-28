import os

volleyball_dir = r"f:\playz\playz-frontend-user\redesign\lib\view\USER\Home\Scoreboard\Volleyball"

reverted_files = 0

for root, dirs, files in os.walk(volleyball_dir):
    for file in files:
        if file.endswith('.dart') and file != "volleyball_colors.dart":
            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            if "VolleyballColors" in content:
                content = content.replace(
                    "import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/volleyball_colors.dart';",
                    "import 'package:redesign/theme/app_colors.dart';"
                )
                content = content.replace("VolleyballColors", "AppColors")
                
                with open(path, 'w', encoding='utf-8') as f:
                    f.write(content)
                reverted_files += 1

colors_file = os.path.join(volleyball_dir, "volleyball_colors.dart")
if os.path.exists(colors_file):
    os.remove(colors_file)

print(f"Reverted theme in {reverted_files} files!")
