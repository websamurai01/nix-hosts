{ pkgs, username, hostPath, ... }:

{
  system.activationScripts.tilde-stow = {
    text = ''
      USER_HOME="/home/${username}"

      if [ -d "${hostPath}/tilde" ]; then
          echo
          echo ":: Stowing ${hostPath}/tilde..."
          echo

          ${pkgs.util-linux}/bin/runuser -u ${username} -- mkdir -p "$USER_HOME/.config"

          ${pkgs.util-linux}/bin/runuser -u ${username} -- \
            ${pkgs.stow}/bin/stow --adopt -d "${hostPath}" -t "$USER_HOME" tilde --verbose=1
      fi
    '';
    deps = [ "users" ];
  };
}
