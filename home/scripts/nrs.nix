{ pkgs, identity, ... }:

let
  nrs = pkgs.writeShellApplication {
    name = "nrs";
    runtimeInputs = with pkgs; [ nixos-rebuild coreutils ];
    text = ''
      REPO_DIR="${identity.repoPath}"
      
      # 1. Priority: CLI Argument ($1)
      # 2. Fallback: Current system hostname
      TARGET_HOST="''${1:-$(hostname)}"
      TARGET_PATH="$REPO_DIR/$TARGET_HOST"

      if [ ! -d "$TARGET_PATH" ]; then
        echo ":: Error: Host directory $TARGET_PATH does not exist in $REPO_DIR"
        exit 1
      fi

      cd "$REPO_DIR" || exit 1

      echo
      echo ":: Rebuilding NixOS for [$TARGET_HOST]..."
      echo

      if sudo nixos-rebuild switch --flake "$TARGET_PATH#$TARGET_HOST"; then
          echo
          echo ":: SUCCESS: Configuration for [$TARGET_HOST] applied."
      else
          echo
          echo ":: FAILURE: Rebuild failed."
          exit 1
      fi
    '';
  };
in
{
  environment.systemPackages = [ nrs ];
}
