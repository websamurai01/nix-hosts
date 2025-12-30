{ pkgs, identity, repoPath, hostPath, ... }:

let
  nrs = pkgs.writeShellApplication {
    name = "nrs";
    runtimeInputs = with pkgs; [ nixos-rebuild coreutils gum ];
    text = ''

      wb() { gum style --foreground 7 --bold "$*"; }
      rb() { gum style --foreground 1 --bold "$*"; }
      gb() { gum style --foreground 2 --bold "$*"; }
      bb() { gum style --foreground 4 --bold "$*"; }
      w() { gum style --foreground 7 "$*"; }
      r() { gum style --foreground 1 "$*"; }
      g() { gum style --foreground 2 "$*"; }
      b() { gum style --foreground 4 "$*"; }

      TARGET_HOST="''${1:-$(hostname)}"

      if [ ! -d "${hostPath}" ]; then
        echo ":: Error: Host directory ${hostPath} does not exist in ${repoPath}"
        exit 1
      fi

      cd "${repoPath}" || exit 1

      echo
      gum join --horizontal ":: Rebuilding NixOS for " "$(b "$TARGET_HOST")" "..."
      echo

      if
          sudo nixos-rebuild switch --flake "${hostPath}#$TARGET_HOST"
      then
          tilde-stow
          gum join --horizontal ":: " "$(gb "SUCCESS ")" "Configuration for " "$(b "$TARGET_HOST ")" "applied."
      else
          echo
          gum join --horizontal ":: " "$(rb "FAILURE ")" "Build failed."
          exit 1
      fi
    '';
  };
in
{
  environment.systemPackages = [ nrs ];
}
