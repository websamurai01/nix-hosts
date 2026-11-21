{ ... }:

{
  flake.nixosModules.nt = { pkgs, id, ... }:
    let
      nt = pkgs.writeShellApplication {
        name = "nt";
        runtimeInputs = with pkgs; [ nh coreutils gum ];
        text = ''
          rb() { gum style --foreground 1 --bold "$*"; }
          gb() { gum style --foreground 2 --bold "$*"; }
          yb() { gum style --foreground 3 --bold "$*"; }
          bb() { gum style --foreground 4 --bold "$*"; }
          mb() { gum style --foreground 5 --bold "$*"; }
          wb() { gum style --foreground 7 --bold "$*"; }
          r() { gum style --foreground 1 "$*"; }
          g() { gum style --foreground 2 "$*"; }
          y() { gum style --foreground 3 "$*"; }
          b() { gum style --foreground 4 "$*"; }
          m() { gum style --foreground 5 "$*"; }
          w() { gum style --foreground 7 "$*"; }

          REPO_DIR="${id.repoPath}"
          TARGET_HOST="''${1:-}"

          if [ -z "$TARGET_HOST" ]; then
            echo "$(r "[!] ")" "Usage: nt <hostname>"
            exit 1
          fi

          cd "$REPO_DIR" || exit 1
          TARGET_PATH="$REPO_DIR/hosts/$TARGET_HOST"

          if [ ! -d "$TARGET_PATH" ]; then
            echo "$(r "[!] ")" "Error: Host directory $(b "$TARGET_HOST") does not exist in $REPO_DIR/hosts"
            exit 1
          fi

          echo
          gum join --horizontal "$(m "[>] ")" "Verifying Flake for " "$(b "[$TARGET_HOST]")" "..."
          echo

          if nh os build "$REPO_DIR" --hostname "$TARGET_HOST"; then
              echo
              gum join --horizontal "$(g "[+] ")" "$(b "$TARGET_HOST")" " is valid and buildable."
          else
              echo
              gum join --horizontal "$(r "[!] ")" "$(b "$TARGET_HOST")" " build failed."
              exit 1
          fi
        '';
      };
    in
    {
      environment.systemPackages = [ nt ];
    };
}
