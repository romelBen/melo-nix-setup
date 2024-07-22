# melo-nix-setup
## Setup
This repo encapsulates a range of Nix goodies that I use to declutter and bring order to my entire laptop environment, including:

- My nix-darwin and Home Manager configuration
- Shell aliases and helper scripts

## Before You Begin
You must change the following:
- Change the username and hostname to your specs in `flake.nix` and `./home-manager/*.nix`. Username would be your name you have assigned to your local computer and hostname is already done but to understand what is being pulled, run the following command: `hostname -s` or `scutil --get LocalHostName`.

## Setup Nix On Local Workstation
To make life easier, I created a Makefile to install the pre-requisites necessary for your local workstation:
```sh
https://github.com/romelBen/melo-nix-setup.git melo-nix-setup
cd melo-nix-setup
make
```

With Nix installed and flakes enabled, this is all that I need to run to stand up a new machine according to my exact specifications, including configuration for [Vim](./nix-darwin/home-manager/neovim.nix), [zsh](./nix-darwin/home-manager/zsh.nix), [Visual Studio Code](./nix-darwin/home-manager/vscode.nix), [Git](./nix-darwin/home-manager/git.nix), and more.
With this approach, this will eliminate [Homebrew] in use from my machine.

## Troubleshooting
You will receive an error in regards to `experimental-features = nix-command flakes` when running `make`. This is something I fixing currently so this will soon be removed. To fix this issue, all that is needed is to run the following:
```shell
echo "experimental-features = nix-command flakes" | sudo tee /etc/nix/nix.conf
```

Once ran, rerun `make` and you should be good as new.

## Things To Do
Still need to add/configure/remove programs:
- [] Remove homebrew, docker, and more
- [] Add k9s, rancher desktop, asdf, and more
- [] Fix layout of icons at the bottom of macOS dash

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
