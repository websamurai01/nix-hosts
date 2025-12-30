{ pkgs, identity, ... }:

let
  nt = pkgs.writeShellApplication {
    name = "nt";
    runtimeInputs = with pkgs; [ nix git ];
    text = ''
      REPO_DIR="${identity.repoPath}"
      TARGET_HOST="''${1:-}"

      if [ -z "$TARGET_HOST" ]; then
        echo "Usage: nt <hostname>"
        exit 1
      fi

      cd "$REPO_DIR" || exit 1
      TARGET_PATH="$REPO_DIR/$TARGET_HOST"

      if [ ! -d "$TARGET_PATH" ]; then
        echo ":: Error: Host directory $TARGET_PATH does not exist."
        exit 1
      fi

      echo
      echo ":: Verifying Flake for [$TARGET_HOST] (No Link)..."
      echo

      # We point directly to the system derivation inside the flake
      if nix build "$TARGET_PATH#nixosConfigurations.$TARGET_HOST.config.system.build.toplevel" --no-link; then
          echo
          echo ":: SUCCESS: $TARGET_HOST is valid and buildable."
      else
          echo
          echo ":: FAILURE: $TARGET_HOST build failed."
          exit 1
      fi
    '';
  };
in
{
  environment.systemPackages = [ nt ];
}
