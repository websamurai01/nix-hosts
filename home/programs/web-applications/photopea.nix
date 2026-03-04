{ pkgs, lib, username, config, ... }:

let
  wrapper = config.my.chromium.wrapper;
  url = "https://www.photopea.com/";
  name = "Photopea";
  icon = "photopea";
in
{
  home-manager.users.${username} = {
    xdg.desktopEntries.${name} = {
      inherit name icon;
      genericName = "${name}";
      exec = "${wrapper}/bin/chromium-browser --app=${url}";
      terminal = false;
    };
  };
}
