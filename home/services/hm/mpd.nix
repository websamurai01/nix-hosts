{ pkgs, config, lib, ... }:

{

  # --- MPD Service ---
  services.mpd = {
    enable = true;
    
    musicDirectory = "/mnt/drives/hdd1000.1/backup-everything/FB2K/Library Historyfied!";
    
    dbFile = "${config.home.homeDirectory}/.config/mpd/database";
    
    dataDir = "${config.home.homeDirectory}/.config/mpd";
    playlistDirectory = "${config.home.homeDirectory}/.config/mpd/playlists";
    
    extraConfig = ''
      auto_update "yes"
      
      sticker_file "~/.config/mpd/sticker.sql"
      
      audio_output {
        type            "pipewire"
        name            "PipeWire Sound Server"
      }
    '';

    network.startWhenNeeded = true;
  };

}
