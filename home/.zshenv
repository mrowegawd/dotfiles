export DOTFILES="${HOME}/.dotfiles"

source "${DOTFILES}/variables.sh"
if [ -e /home/mr00x/.nix-profile/etc/profile.d/nix.sh ]; then . /home/mr00x/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
