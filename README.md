# melo-nix-setup
## Setup
This repo encapsulates a range of Nix goodies that I use to declutter and bring order to my entire laptop environment, including:

- My [nix-darwin] and [Home Manager][hm] configuration
- Shell aliases and helper scripts

Steps to setup your environment:
1. You will need to run this command to setup your environment: `nix --extra-experimental-features nix-command --extra-experimental-features flakes build [folder]`
What I run to apply my [nix-darwin] configuration (which in turn applies my [Home Manager][hm] config):
```shell
nix develop --command reload
```

That's right: with Nix installed and [flakes enabled][flakes], this is all that I need to run to stand up a new machine according to my exact specifications, including configuration for [Vim](./nix-darwin/home-manager/neovim.nix), [zsh](./nix-darwin/home-manager/zsh.nix), [Visual Studio Code](./nix-darwin/home-manager/vscode.nix), [Git](./nix-darwin/home-manager/git.nix), and more.
With this approach, this will eliminate [Homebrew] in use from my machine.

## Acknowledgements
Great inspiration on utilizing Nix setup is from Luc Perkins in his blog and repository which was a great help:
- [Building a highly optimized home environment with Nix](https://determinate.systems/posts/nix-home-env/)
- [nome](https://github.com/the-nix-way/nome/tree/main)