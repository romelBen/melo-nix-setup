# melo-nix-setup
## Setup
This repo encapsulates a range of Nix goodies that I use to declutter and bring order to my entire laptop environment, including:

- My nix-darwin and Home Manager configuration
- Shell aliases and helper scripts

## Before You Begin
Setup your environment:
Before you move forward, you will receive an error on `--extra-experimental-features` on `nix-command`. What you will need to do the following:
- Add `experimental-features = nix-command flakes` onto `/etc/nix/nix.conf`

### Using `nix build`
> [!IMPORTANT]
> If you are going to use `nix build`, this will do an install to your local workstation of all the packages I have listed. If you are to run build and run `./result/activate`, it will overwrite and install all packages necessary on your local workstation so USE CAUTION when running the command. If you hate your computer and like to live on the edge, do it. If you don't, use a VM or a used Macbook on Craigslist/Ebay to see how it works.

From here this is where the fun begins:
1. To build the configuration, make sure to change the username from `romelben` to your own. Look in the `flake.nix` in the root directory and change the `username` to your own. Once you change it, run the following:
```shell
nix build .#darwinConfigurations.romelben-aarch64-darwin.system
```

2. After building, run the followin below:
```shell
# Then activate the build that we did before
./result/activate
```

With Nix installed and flakes enabled, this is all that I need to run to stand up a new machine according to my exact specifications, including configuration for [Vim](./nix-darwin/home-manager/neovim.nix), [zsh](./nix-darwin/home-manager/zsh.nix), [Visual Studio Code](./nix-darwin/home-manager/vscode.nix), [Git](./nix-darwin/home-manager/git.nix), and more.
With this approach, this will eliminate [Homebrew] in use from my machine.

### Troubleshooting
You will more than likely be brought up with an error like so:
```shell
error: Unexpected files in /etc, aborting activation
The following files have unrecognized content and would be overwritten:

  /etc/nix/nix.conf

Please check there is nothing critical in these files, rename them by adding .before-nix-darwin to the end, and then try again.
```

To fix this issue, run the following command to fix this: `sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin`

The reasoning behind this is there is a bug when running any `nix` command, it will want you to remove it since `nix` is being built from the ground up. However, this error occurs when you use `nix` commands the first time.

## Acknowledgements
Great inspiration on utilizing Nix setup is from Luc Perkins in his blog and repository which was a great help:
- [Building a highly optimized home environment with Nix](https://determinate.systems/posts/nix-home-env/)
- [nome](https://github.com/the-nix-way/nome/tree/main)
