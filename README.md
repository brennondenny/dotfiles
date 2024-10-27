# Dotfiles and MacOS Setup

## Installation
Installs CLI Tools, Applications, and updates MacOS settings

```zsh
$ sh <(curl -L https://nixos.org/nix/install)
```
```zsh
$ nix-shell -p git --run 'git clone https://github.com/brennondenny/dotfiles.git dotfiles'
```
```zsh
$ nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake ~/dotfiles/nix/darwin#based
```
```zsh
cd dotfiles
```
```zsh
stow .
```

## Dev Tools


### VS Code

#### Extensions
#### Theme
#### Settings

### Warp (Terminal)
#### Theme
