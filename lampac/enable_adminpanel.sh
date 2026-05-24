#!/bin/bash
MANIFEST="/lampac/module/AdminPanel/manifest.json"

if [ -f "$MANIFEST" ]; then
    # Включаем модуль
    CONTENT=$(cat "$MANIFEST")
    UPDATED=$(echo "$CONTENT" | jq '.enable = true')
    echo "$UPDATED" > "$MANIFEST"
    echo "AdminPanel module enabled"
else
    echo "AdminPanel manifest not found at $MANIFEST — skipping"
fi
