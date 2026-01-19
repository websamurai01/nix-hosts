{ pkgs, username, ... }:

{
  system.activationScripts.install-reminder-scripts = {
    text = ''
      install -D -m 755 ${./waybar-reminder.sh} /home/${username}/.scripts/waybar-reminder.sh
      install -D -m 755 ${./../tilde/.commands/wayskip} /home/${username}/.commands/wayskip
    '';
    deps = [];
  };
}
