WIP

# Manual Install instructions

```
mkdir -p ~/local && cd ~/local
git clone git@github.com:mao-liu/nix-profile.git

# add this to the top of ~/.zshrc
source ~/local/nix-profile/profiles/.zshrc

# add this to the top of ~/.profile
source ~/local/nix-profile/profiles/.profile

# replace vscode settings
cd ~/Library/Application\ Support/Code/User
ln -s ~/local/nix-profile/third_party/vscode/settings.json .

```
