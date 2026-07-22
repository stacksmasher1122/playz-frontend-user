#!/bin/bash
TARGET="redesign/lib/view/USER/Home/Scoreboard/Football"
find "$TARGET" -type f -name "*.dart" > files_to_process.txt

while read p; do
  # Many files will have incorrect TextPrimary70 or textPrimary.
  # Let's import the app_colors carefully and fix known flutter issues.

  if ! grep -q "import 'package:flutter/material.dart';" "$p"; then
    sed -i "1i import 'package:flutter/material.dart';" "$p"
  fi

  sed -i "s/AppColors.textPrimary70/AppColors.textPrimary.withOpacity(0.7)/g" "$p"

done < files_to_process.txt
