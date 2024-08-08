#!/bin/sh

# Set source and target directories
source_font_dir="/Users/danrodriguez/Google Drive/My Drive/3 Resources/1 tech/fonts"

echo "Installing fonts from:" $source_font_dir

# if an argument is given it is used to select which fonts to install
prefix="$1"

if test "$(uname)" = "Darwin" ; then
  # MacOS
  target_font_dir="$HOME/Library/Fonts"
else
  # Linux
  target_font_dir="$HOME/.local/share/fonts"
  mkdir -p $target_font_dir
fi

# Copy all fonts to user fonts directory
echo "Copying fonts..."
find "$source_font_dir" \( -name "$prefix*.[ot]tf" -or -name "$prefix*.pcf.gz" \) -type f -print0 | xargs -0 -n1 -I % cp "%" "$target_font_dir/"

# Reset font cache on Linux
if which fc-cache >/dev/null 2>&1 ; then
    echo "Resetting font cache, this may take a moment..."
    fc-cache -f "$target_font_dir"
fi

echo "Fonts installed to $target_font_dir"
