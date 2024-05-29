#!/bin/sh

INSTALL_DIR="${INSTALL_DIR:-$HOME/dev/github.com/soujin8/dotfiles}"

if [ -d "$INSTALL_DIR" ]; then
	echo "Already cloned."
else
	echo "Installing dotfiles..."
	git clone https://github.com/soujin8/dotfiles.git "$INSTALL_DIR"
fi

/bin/bash "$INSTALL_DIR/scripts/setup.bash"

