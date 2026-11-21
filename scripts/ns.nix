{ ... }:

{
  flake.nixosModules.ns = { pkgs, id, ... }:
    let
      ns = pkgs.writeShellApplication {
        name = "ns";
        runtimeInputs = with pkgs; [ git coreutils gum ];
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

          MSG="''${1:-$(date -u +'%Y-%m-%d %H:%M UTC')}"
          cd "${id.repoPath}"

          echo
          gum join --horizontal "$(m "[>] ")" "Committing local changes..."
          git add .
          if ! git diff-index --quiet HEAD --; then
              git commit -m "$MSG"
          else
              gum join --horizontal "$(y "[~] ")" "No changes to commit locally."
          fi

          if git remote | grep -q "^origin$"; then
              RAW_ADDR=$(git remote get-url origin)
              TARGET_ADDR=''${RAW_ADDR%.git}
              TARGET_ADDR=''${TARGET_ADDR%/}
              BRANCH=$(git branch --show-current)
              BRANCH="''${BRANCH:-main}"

              echo
              gum join --horizontal "$(m "[>] ")" "Pushing to Origin: " "$(y "$TARGET_ADDR")" "..."

              if git push -u origin "$BRANCH"
              then
                  gum join --horizontal "$(g "[+] ")" "Pushed to Origin."
              else
                  gum join --horizontal "$(r "[!] ")" "Push failed."
              fi
          fi
        '';
      };
    in
    {
      environment.systemPackages = [ ns ];
    };
}
