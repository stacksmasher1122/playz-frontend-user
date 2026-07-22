#!/bin/bash
TARGET="redesign/lib/view/USER/Home/Scoreboard/Football"
find "$TARGET" -type f -name "*.dart" > files_to_process.txt

while read p; do
  sed -i "s/Color(0xFFC6FF00)/AppColors.accent/g" "$p"
  sed -i "s/Colors.black.withValues(alpha: 0.5)/AppColors.surface/g" "$p"
  sed -i "s/Colors.black.withValues(alpha: 0.3)/AppColors.surface/g" "$p"
  sed -i "s/Colors.black/AppColors.background/g" "$p"
  sed -i "s/Colors.white/AppColors.textPrimary/g" "$p"
  sed -i "s/Colors.grey.shade900/AppColors.surface/g" "$p"
  sed -i "s/Colors.grey.shade800/AppColors.card/g" "$p"
  sed -i "s/Colors.grey.shade600/AppColors.textSecondary/g" "$p"
  sed -i "s/Colors.grey.shade500/AppColors.textSecondary/g" "$p"
  sed -i "s/Colors.grey/AppColors.textSecondary/g" "$p"
done < files_to_process.txt
