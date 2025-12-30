{ pkgs, identity, hostPath, ... }:

let
  ns = pkgs.writeShellApplication {
    name = "ns";
    runtimeInputs = with pkgs; [ git stow repomix ];
    text = ''
      REPO_DIR="${identity.repoPath}"
      HOST_PATH="${hostPath}"
      MSG="''${1:-$(date -u +'%Y-%m-%d %H:%M UTC')}"

      cd "$REPO_DIR" || exit 1

      if [ -d "$HOST_PATH/tilde" ]; then
          echo
          echo ":: Stowing $HOST_PATH/tilde..."
          echo

          mkdir -p "$HOME/.config"

          stow --adopt -d "$HOST_PATH" -t "$HOME" tilde --verbose=1
      fi

      echo
      echo ":: Syncing Git..."
      echo
      git add .
      git commit -m "$MSG"
      git push
          
      if command -v repomix &> /dev/null; then
          repomix
      fi
    '';
  };
in
{
  environment.systemPackages = [ ns ];
}
