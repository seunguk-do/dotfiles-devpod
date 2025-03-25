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
)

create_symlinks "${common_items[@]}"

curl -o "$HOME/.tmux.conf" https://raw.githubusercontent.com/seunguk-do/dotfiles/main/tmux.conf
curl -o "$HOME/.bash_profile" https://raw.githubusercontent.com/seunguk-do/dotfiles/main/bash_profile

mkdir -p "$XDG_CONFIG_HOME/nvim"
git clone https://github.com/seunguk-do/dotfiles.git "$HOME/temp_dotfiles"
cp -r "$HOME/temp_dotfiles/nvim/"* "$XDG_CONFIG_HOME/nvim/"
rm -rf "$HOME/temp_dotfiles"

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
  gh
)

# Iterate over the array and install each package
for package in "${brew_packages[@]}"; do
  echo "Installing $package..."
  $HOME/.homebrew/bin/brew install "$package"
done

# set up prompt
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
#
# # devpod
# curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-darwin-arm64" && sudo install -c -m 0755 devpod /usr/local/bin && rm -f devpod
# devpod use ide none
