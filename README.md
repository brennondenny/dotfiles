# Dotfiles and MacOS Setup

## Installation
Installs CLI Tools, Applications, and updates MacOS settings

Install XCode

```zsh
$ sh <(curl -L https://nixos.org/nix/install)
```
```zsh
$ nix-shell -p git --run 'git clone https://github.com/brennondenny/dotfiles.git dotfiles'
```
```zsh
$ nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake ~/dotfiles/nix#based
```
```zsh
cd dotfiles
```
```zsh
stow .
```
```zsh
darwin-rebuild switch --flake ~/.config/nix#based
```
