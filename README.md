# melo-nix-setup
## Setup
This repo encapsulates a range of Nix goodies that I use to declutter and bring order to my entire laptop environment, including:

- My nix-darwin and Home Manager configuration
- Shell aliases and helper scripts

## Before You Begin
You must change the following:
- Change the username and hostname to your specs in `flake.nix` and `./home-manager/*.nix`. Username would be your name you have assigned to your local computer and hostname is already done but to understand what is being pulled, run the following command: `hostname -s` or `scutil --get LocalHostName`.

### Using `nix develop`
> [!IMPORTANT]
> `nix develop` (carbon copy of `nix shell`) is more centered on recreating your build environment for single packages. You are dropped into a shell that is as close as possible to the nix builder environment. This is more centered on locally developed pacakges.

Installation process is not as difficult as `nix build`:
1. Run the following command which will bring you into the shell command of the development:
```shell
nix develop --extra-experimental-features nix-command --extra-experimental-features flakes --command reload
```
As much as I hate this long name for using `--command reload`, there is an error that pops up because of this. This is where the Troubleshooting section comes in handy to help out but alas, this should stop the error.

### Using `nix build`
> [!IMPORTANT]
> `nix build` will do an install to your local workstation of all the packages I have listed. If you are to run build and run `./result/activate`, it will overwrite and install all packages necessary on your local workstation so USE CAUTION when running the command. If you hate your computer and like to live on the edge, do it. If you don't, use a VM or a used Macbook on Craigslist/Ebay to see how it works.

From here this is where the fun begins:
1. To build the configuration, run the following:
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

## Testing
For testing purposes in Mac, it will be best to use [UTM](https://getutm.app) and setup an environment similar to your own for macOS:
1. Install [UTM](https://getutm.app)
2. Download [macOS IPSW recovery file](https://ipsw.me/product/Mac)
3. Create a macOS VM in UTM using the downloaded IPSW file
4. Run `xcode-select --install` in the new VM
5. (Optional) Clone the VM to a new one for easy rollback ([UTM doesn't support snapshot yet](https://github.com/utmapp/UTM/issues/2688))
6. Run the above commands of your choice: [nix build](#using-nix-build) or [nix develop](#using-nix-develop).

## Acknowledgements
Great inspiration on utilizing Nix setup is from Luc Perkins in his blog and repository which was a great help:
- [Building a highly optimized home environment with Nix](https://determinate.systems/posts/nix-home-env/)
- [nome](https://github.com/the-nix-way/nome/tree/main)
