{ pkgs, identity, repoPath, hostPath, ... }:

let
  tilde-stow = pkgs.writeShellApplication {
    name = "tilde-stow";
    runtimeInputs = with pkgs; [ stow coreutils gum ];
    text = ''

      wb() { gum style --foreground 7 --bold "$*"; }
      rb() { gum style --foreground 1 --bold "$*"; }
      gb() { gum style --foreground 2 --bold "$*"; }
      bb() { gum style --foreground 4 --bold "$*"; }
      w() { gum style --foreground 7 "$*"; }
      r() { gum style --foreground 1 "$*"; }
      g() { gum style --foreground 2 "$*"; }
      b() { gum style --foreground 4 "$*"; }
      
      mkdir -p "$HOME/.config"

      if [ -d "${repoPath}/common/tilde" ]; then
          echo
          gum join --horizontal ":: Stowing " "$(b "$HOSTNAME") " "commons..."
          cd "${repoPath}/common"
          stow --adopt -t "$HOME" tilde --verbose=1
          echo
      fi

      if [ -d "${hostPath}/tilde" ]; then
          gum join --horizontal ":: Stowing " "$(b "$HOSTNAME") " "specifics..."
          cd "${hostPath}"
          stow --adopt -t "$HOME" tilde --verbose=1
          echo
      fi

    '';
  };
in
{
  environment.systemPackages = [ tilde-stow ];
}
