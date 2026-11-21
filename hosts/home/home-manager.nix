{ id, ... }:

{
  hm = { config, ... }: {
    xdg.configFile."user-dirs.conf".text = "enabled=False";

    xdg.userDirs = {
      enable = true;
      setSessionVariables = true;
      createDirectories = false;

      desktop = "${config.home.homeDirectory}/Documents";
      music = "${config.home.homeDirectory}/Documents";
      pictures = "${config.home.homeDirectory}/Documents";
      publicShare = "${config.home.homeDirectory}/Documents";
      templates = "${config.home.homeDirectory}/Documents";
      videos = "${config.home.homeDirectory}/Documents";

      download = "/run/media/${id.user}/1000xhome/downloads";
    };
  };
}
