#!/usr/bin/env bash

# Without this, the ln command will create a symlink inside the ~/.hammerspoon directory
if [ -d ~/.hammerspoon ]; then
  echo "Moving existing ~/.hammerspoon to trash"
  trash ~/.hammerspoon
fi

ln -sfvn ~/projects/hammerspoon-config ~/.hammerspoon
