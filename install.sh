#!/bin/sh

INSTALL_DIR="${INSTALL_DIR:-$HOME/dev/github.com/m-88888888/dotfiles}"

if [ -d "$INSTALL_DIR" ]; then
	echo "Updating dotfiles..."
	git -C "$INSTALL_DIR" pull
else
	echo "Installing dotfiles..."
	git clone https://github.com/m-88888888/dotfiles.git "$INSTALL_DIR"
fi

/bin/bash "$INSTALL_DIR/scripts/setup.bash"

