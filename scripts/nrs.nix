{ ... }:

{
  flake.nixosModules.nrs = { pkgs, id, ... }:
    let
      nrs = pkgs.writeShellApplication {
        name = "nrs";
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

          TARGET_HOST="''${1:-$(hostname)}"

          if [ ! -d "${id.repoPath}/hosts/$TARGET_HOST" ]; then
            echo "$(r "[!] ")" "Error: Host directory ${id.repoPath}/hosts/$TARGET_HOST does not exist in ${id.repoPath}"
            exit 1
          fi

          cd "${id.repoPath}" || exit 1

          git add .

          export NH_FLAKE="${id.repoPath}"

          if nh os switch "${id.repoPath}" --hostname "$TARGET_HOST"; then
              echo
              gum join --horizontal "$(g "[+] ")" "Configuration for " "$(b "$TARGET_HOST")" " applied."
          else
              echo
              gum join --horizontal "$(r "[!] ")" "Build failed."
              exit 1
          fi
        '';
      };
    in
    {
      environment.systemPackages = [ nrs ];
    };
}
