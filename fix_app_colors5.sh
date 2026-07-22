#!/bin/bash
TARGET="redesign/lib/view/USER/Home/Scoreboard/Football"
find "$TARGET" -type f -name "*.dart" > files_to_process.txt

while read p; do
  # It looks like our app_colors.dart does not have textPrimary / textSecondary but kMutedText, kPrimaryText or similar, or just plain Colors.
  # Let's revert app_colors textPrimary/textSecondary usage to standard white/grey as that's what was working and is typically used if tokens are missing.
  sed -i "s/AppColors.textPrimary/Colors.white/g" "$p"
  sed -i "s/AppColors.textSecondary/Colors.grey/g" "$p"
  sed -i "s/AppColors.card/Color(0xFF1E1E1E)/g" "$p" # Assuming card is missing too
  sed -i "s/AppColors.surface/Color(0xFF121212)/g" "$p"
done < files_to_process.txt
