{
  description = "Based Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
      nixpkgs.config.allowUnfree = true;
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
        ];

      homebrew = {
        enable = true;
        brews = [
          "cocoapods"
          "eza"
          "ffmpeg"
          "fnm"
          "gh"
          "git-standup"
          "git"
          "imagemagick"
          "mas"
          "neovim"
          "python@3.12" 
          "starship"
          "stow"
          "watchman"
          "zoxide"
          "zsh-autosuggestions"
          "zsh-syntax-highlighting"
        ];
        casks = 
        [
          "1password"
          "adguard"
          "aldente"
          "amie"
          "arc"
          "cleanmymac"
          "cleanshot"
          "discord"
          "downie"
          "eloston-chromium"
          "firefox@developer-edition"
          "font-jetbrains-mono-nerd-font"
          "font-jetbrains-mono"
          "fork"
          "github"
          "iina"
          "jordanbaird-ice"
          "music-decoy"
          "numi"
          "obs"
          "proton-drive"
          "proton-mail"
          "raycast"
          "sim-daltonism"
          "sketch"
          "spotify"
          "teamviewer"
          "visual-studio-code"
          "warp"
        ];
        taps = [
        ];
        masApps = {
          gapplin = 768053424;
          keystroke = 1572206224;
          mymind = 1532801185;
          parcel = 639968404;
          photomator = 1444636541;
          pixelmator = 1289583905;
          spring = 6670408493;
        };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };
    
      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      system.defaults = {
        dock.appswitcher-all-displays = true;
        dock.autohide = true;
        dock.autohide-delay = 0.24;
        dock.autohide-time-modifier = 0.75;
        dock.expose-animation-duration = 1.0;
        dock.mineffect = "scale";
        dock.minimize-to-application = true;
        dock.orientation = "bottom";
        dock.show-recents = false;
        finder.FXEnableExtensionChangeWarning = false;
        finder.FXPreferredViewStyle = "clmv";
        finder.ShowPathbar = true;
        NSGlobalDomain.AppleShowAllFiles = true;
      };

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."based" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            # Apple Silicon Only:
            enableRosetta = true;
            # User owning the Homebrew prefix
            user = "denny";
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."based".pkgs;
  };
}
