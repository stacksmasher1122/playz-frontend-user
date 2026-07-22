#!/bin/bash
TARGET="redesign/lib/view/USER/Home/Scoreboard/Football"
find "$TARGET" -type f -name "*.dart" > files_to_process.txt

while read p; do
  if ! grep -q "import 'package:flutter/material.dart';" "$p"; then
    sed -i '1i import '"'"'package:flutter/material.dart'"'"';' "$p"
  fi
  if ! grep -q "import 'package:redesign/theme/app_colors.dart';" "$p"; then
    sed -i '2i import '"'"'package:redesign/theme/app_colors.dart'"'"';' "$p"
  fi
done < files_to_process.txt
