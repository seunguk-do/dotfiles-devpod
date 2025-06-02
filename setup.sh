#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles-devpod"
XDG_CONFIG_HOME="$HOME/.config"
BREW="$HOME/.homebrew/bin/brew"

# Install Homebrew
if [ ! -d "$HOME/.homebrew" ]; then
  mkdir -p $HOME/.homebrew
  curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $HOME/.homebrew
fi

# Install packages
packages=(fd ripgrep lazygit fzf neovim tmux gh)

for pkg in "${packages[@]}"; do
  $BREW install "$pkg"
done

# Install Pure prompt
[ ! -d "$HOME/.zsh/pure" ] && {
  mkdir -p "$HOME/.zsh"
  git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
}

# Install tools
curl -sfL https://direnv.net/install.sh | bash
curl -LsSf https://astral.sh/uv/install.sh | sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Install Blender
BLENDER_VERSION=4.4.3
wget -O- https://download.blender.org/release/Blender${BLENDER_VERSION%.*}/blender-${BLENDER_VERSION}-linux-x64.tar.xz | tar -xJ -C $HOME/.local/lib
ln -sf $HOME/.local/lib/blender-${BLENDER_VERSION}-linux-x64/blender $HOME/.local/bin/blender

# Create symlinks
create_symlink() {
  [ -L "$3" ] && unlink "$2"
  [ ! -e "$2" ] && ln -s "$DOTFILES_DIR/$1" "$2" && echo "Created symlink for $1"
}

create_symlink "dotfiles/tmux.conf" "$HOME/.tmux.conf"
create_symlink "dotfiles/nvim" "$XDG_CONFIG_HOME/nvim"
create_symlink "dotfiles/bash_profile" "$HOME/.bash_profile"
create_symlink "zshrc" "$HOME/.zshrc"
