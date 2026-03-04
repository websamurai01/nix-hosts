{ pkgs, lib, username, config, ... }:

let
  wrapper = config.my.chromium.wrapper;
  url = "https://figma.com";
  name = "Figma";
in
{
  home-manager.users.${username}.xdg.desktopEntries.${name} = {
    inherit name;
    genericName = "Graphic Design Tool";
    exec = "${wrapper}/bin/chromium-browser --app=${url}";
    terminal = false;
    icon = "figma";
    categories = [ "Graphics" "Network" ];
  };
}
