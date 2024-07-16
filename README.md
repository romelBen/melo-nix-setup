# melo-nix-setup
## Setup
This repo encapsulates a range of Nix goodies that I use to declutter and bring order to my entire laptop environment, including:

- My nix-darwin and Home Manager configuration
- Shell aliases and helper scripts

### Before You Begin
Setup your environment:
Before you move forward, you will receive an error on `--extra-experimental-features` on `nix-command`. What you will need to do the following:
- Add `experimental-features = nix-command flakes` onto `/etc/nix/nix.conf`

From here this is where the fun begins:
> [!IMPORTANT] This will take quite a while to build the first time, probably 10-15 minutes. However, once done it is cached and you can update your environment to the way you want.
1. To build the configuration, make sure the username `romelben` is different from mine. Look in the `flake.nix` in the root directory and change the `username` to your own:
```shell
nix build .#darwinConfigurations.romelben-aarch64-darwin.system
```

2. Once the build is complete, run the below command:
```shell
# Move the /etc/nix/nix.conf
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin

# Then activate the build that we did before
./result/activate
```

With Nix installed and flakes enabled, this is all that I need to run to stand up a new machine according to my exact specifications, including configuration for [Vim](./nix-darwin/home-manager/neovim.nix), [zsh](./nix-darwin/home-manager/zsh.nix), [Visual Studio Code](./nix-darwin/home-manager/vscode.nix), [Git](./nix-darwin/home-manager/git.nix), and more.
With this approach, this will eliminate [Homebrew] in use from my machine.

## Acknowledgements
Great inspiration on utilizing Nix setup is from Luc Perkins in his blog and repository which was a great help:
- [Building a highly optimized home environment with Nix](https://determinate.systems/posts/nix-home-env/)
- [nome](https://github.com/the-nix-way/nome/tree/main)
