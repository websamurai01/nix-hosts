{ pkgs, lib, config, ... }:

let

  listenbrainz-mpd-90-no4m = pkgs.listenbrainz-mpd.overrideAttrs (old: rec {
    pname = "listenbrainz-mpd-90-no4m";
    version = "git";

    src = pkgs.fetchFromGitea {
      domain = "codeberg.org";
      owner = "lewelove";
      repo = "listenbrainz-mpd-90-no4m";
      rev = "main";
      hash = "sha256-ePYk33SuGTiTRquUcVZTdkx4bXayCpWkEK5a/CC0+Yo=";
    };

    cargoHash = lib.fakeHash;
  });

in

{

  # --- ListenBrainz MPD Scrobble Service ---
  systemd.user.services.listenbrainz-mpd-90-no4m = {
    Unit = {
      Description = "ListenBrainz MPD Client (90% Threshold, No 4m Limit)";
      After = [ "mpd.service" ];
      Wants = [ "mpd.service" ];
    };

    Service = {
      ExecStart = "${listenbrainz-mpd-90-no4m}/bin/listenbrainz-mpd";
      Restart = "on-failure";
      RestartSec = "5s";
      Environment = [
        "XDG_CONFIG_HOME=${config.home.homeDirectory}/.config"
        "LISTENBRAINZ_MPD_LOG=debug"
      ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

}
