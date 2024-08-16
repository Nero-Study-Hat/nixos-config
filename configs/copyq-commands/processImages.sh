#!/usr/bin/env bash

link=$(wl-paste)
# link="$1"
echo "link is: ${link}"
if [[ "$link" != *.png && "$link" != *.jpg && "$link" != *.webp &&  "$link" != *.svg && "$link" != *.avif ]]; then
    echo "exit link: ${link}"
    exit 1
fi

file="tmp-image.png"
curl -L "$link" --output "$file"
if [ $(file "$file" | awk '{print $2}') != "PNG" ]; then
    magick mogrify -format png "$file"
fi
cat "$file" | copyq tab Images write image/png -
rm "$file"

copyq tab "clipboard" remove

# remember to uncheck execute automatic commands on select in preferences
# https://miro.medium.com/v2/resize:fit:4388/format:webp/1*4kDk9CZEEJBllqd3Fx549A.png
# https://search.nixos.org/images/nix-logo.png

# link to regex for matching image address: https://regex101.com/r/TinoaL/1