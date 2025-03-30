#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles-devpod"
XDG_CONFIG_HOME="$HOME/.config"

create_symlinks() {
  local items=("$@")
  for item in "${items[@]}"; do
    IFS=':' read -r source target <<<"$item"
    if [ -L "$target" ]; then
      echo "Removing existing symlink $target"
      unlink "$target"
    elif [ -d "$target" ]; then
      echo "Warning: $target is a directory. Skipping..."
      continue
    elif [ -e "$target" ]; then
      echo "Warning: $target already exists. Skipping..."
      continue
    fi
    ln -s "$DOTFILES_DIR/$source" "$target"
    echo "Created symlink for $source"
  done
}

mkdir $XDG_CONFIG_HOME

common_items=(
  "zshrc:$HOME/.zshrc"
  "dotfiles/bash_profile:$HOME/.bash_profile"
  "dotfiles/tmux.conf:$HOME/.tmux.conf"
  "dotfiles/nvim:$XDG_CONFIG_HOME/nvim"
)

create_symlinks "${common_items[@]}"

# brew packages
mkdir $HOME/.homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $HOME/.homebrew

brew_packages=(
  fd
  ripgrep
  lazygit
  fzf
  direnv
  starship
  neovim
  tmux
)

# Iterate over the array and install each package
for package in "${brew_packages[@]}"; do
  echo "Installing $package..."
  $HOME/.homebrew/bin/brew install "$package"
done

# set up prompt
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
