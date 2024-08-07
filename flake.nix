# This flake was initially generated by fh, the CLI for FlakeHub (version 0.1.6)
{
  description = "Project for ARM macOS computers";

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    fh = { url = "https://flakehub.com/f/DeterminateSystems/fh/*"; inputs.nixpkgs.follows = "nixpkgs"; };
    flake-checker = { url = "https://flakehub.com/f/DeterminateSystems/flake-checker/*"; inputs.nixpkgs.follows = "nixpkgs"; };
    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/0.1.*";
    home-manager = { url = "https://flakehub.com/f/nix-community/home-manager/0.2405.*"; inputs.nixpkgs.follows = "nixpkgs"; };
    nix-darwin = { url = "github:LnL7/nix-darwin"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2405.*";
    nuenv = { url = "https://flakehub.com/f/DeterminateSystems/nuenv/0.1.*"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs:
    let
      supportedSystems = [ "aarch64-darwin" ];
      forEachSupportedSystem = f: inputs.nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ inputs.self.overlays.default ];
        };
      });

      stateVersion = "24.05";
      system = "aarch64-darwin";
      username = "romelbenavides";
      caches = {
        nixos-org = {
          cache = "https://cache.nixos.org";
          publicKey = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
        };
        nix-community = {
          cache = "https://nix-community.cachix.org";
          publicKey = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
        };
      };
    in
    {
      inherit (inputs.flake-schemas) schemas;

      devShells = forEachSupportedSystem ({ pkgs }: {
        default =
          let
            reload = pkgs.writeScriptBin "reload" ''
              # CONFIG_NAME=$(scutil --get LocalHostName)
              FLAKE_OUTPUT=".#darwinConfigurations.${username}-${system}.system"
              ${pkgs.nixFlakes}/bin/nix build "''${FLAKE_OUTPUT}" && \
                ./result/sw/bin/darwin-rebuild activate && \
                ${pkgs.zsh}/bin/zsh -c "source ${pkgs.homeDirectory}/.zshrc"
            '';
          in
          pkgs.mkShell {
            name = "romelbenavides";
            packages = with pkgs; [
              nixpkgs-fmt
              reload
            ];
          };
      });

      overlays.default = final: prev: {
        inherit username system;
        homeDirectory =
          if (prev.stdenv.isDarwin)
          then "/Users/${username}"
          else "/home/${username}";
        rev = inputs.self.rev or inputs.self.dirtyRev or null;
        flake-checker = inputs.flake-checker.packages.${system}.default;
        fh = inputs.fh.packages.${system}.default;
      };

      darwinConfigurations."${username}-${system}" = inputs.nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          inputs.determinate.darwinModules.default

          {
            determinate.nix.primaryUser.username = username;
          }

          inputs.self.darwinModules.base
          inputs.self.darwinModules.caching
          inputs.home-manager.darwinModules.home-manager
          inputs.self.darwinModules.home-manager
        ];
      };

      darwinModules = {
        base = { pkgs, ... }: import ./nix-darwin/base {
          inherit pkgs;
          overlays = [
            inputs.nuenv.overlays.default
            inputs.self.overlays.default
          ];
        };

        caching = { ... }: import ./nix-darwin/caching {
          inherit caches username;
        };

        home-manager = { pkgs, ... }: import ./home-manager {
          inherit pkgs stateVersion username;
        };
      };

      nixosConfigurations = rec {
        default = simple;

        simple = inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [ ./nixos/configuration.nix ./nixos/hardware-configuration.nix ];
        };
      };

      templates = import
        ./templates;
    };
}