.POSIX:
.PHONY: default build update

# Variables for URLs and paths
NIX_INSTALL_URL = https://nixos.org/nix/install
BREW_INSTALL_URL = https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
NIX_DARWIN_ARCHIVE = https://github.com/LnL7/nix-darwin/archive/master.tar.gz
NIX_BIN = /nix/var/nix/profiles/default/bin/nix-build
NIX_CMD = /run/current-system/sw/bin/nix
DARWIN_REBUILD = /run/current-system/sw/bin/darwin-rebuild
BREW_BIN = /opt/homebrew/bin/brew
SSH_KEY = ~/.ssh/id_ed25519

default: build

# Install Nix package manager
/nix:
	curl -L $(NIX_INSTALL_URL) | sh
	# TODO: Handle issue https://github.com/LnL7/nix-darwin/issues/149
	sudo rm /etc/nix/nix.conf

# Install nix-darwin
$(DARWIN_REBUILD):
	$(NIX_BIN) $(NIX_DARWIN_ARCHIVE) -A installer
	yes | ./result/bin/darwin-installer

# Install Homebrew
$(BREW_BIN):
	curl -fsSL $(BREW_INSTALL_URL) -o /tmp/brew-install.sh
	NONINTERACTIVE=1 bash /tmp/brew-install.sh

# Generate SSH key
$(SSH_KEY):
	ssh-keygen -t ed25519 -f "$@"

# Build process for ARM Mac computers
build: /nix $(DARWIN_REBUILD) $(BREW_BIN)
	$(DARWIN_REBUILD) && $(NIX_CMD) --experimental-features 'nix-command flakes' develop --command reload
