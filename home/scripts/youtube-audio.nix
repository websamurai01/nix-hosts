{ pkgs, username, ... }:

let
  ytaScript = pkgs.writeShellScriptBin "yta" ''
    #!/usr/bin/env bash
    ${builtins.readFile ./youtube-to-audio.sh}
  '';
in
{
  environment.systemPackages = [ ytaScript ];
  
  system.activationScripts.install-youtube-scripts = {
    text = ''
      # Install YouTube audio downloader script
      install -D -m 755 ${./youtube-to-audio.sh} /home/${username}/.scripts/youtube-to-audio.sh
      install -D -m 755 ${./yta} /home/${username}/.commands/yta
    '';
    deps = [];
  };
}
