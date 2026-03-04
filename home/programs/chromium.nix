{ pkgs, lib, username, config, ... }:

let

  fetchExtension = { id, version, hash }: let
    crx = pkgs.fetchurl {
      url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${lib.versions.major pkgs.ungoogled-chromium.version}&x=id%3D${id}%26installsource%3Dondemand%26uc";
      name = "${id}.crx";
      sha256 = hash;
    };
  in {
    inherit id;
    drv = pkgs.runCommand "ext-${id}" { nativeBuildInputs = [ pkgs.unzip ]; } ''
      unzip ${crx} -d $out || true
    '';
  };

  extensions = {

    chromium-web-store = rec {
      id = "";
      drv = pkgs.stdenv.mkDerivation rec {
        pname = "chromium-web-store";
        version = "1.5.5.2";
        src = pkgs.fetchFromGitHub {
          owner = "NeverDecaf";
          repo = "chromium-web-store";
          rev = "v${version}";
          hash = "sha256-Rr0KVs6Ztqz04CpQSDThn/hi6VZdVZsztPSALUY/fnE=";
        };
        installPhase = "mkdir -p $out; cp -r src/* $out/";
      };
    };
  
    ublock-origin = rec {
      id = "mdcpogggagpjibjhpohkefbfgfaepcik";
      drv = pkgs.stdenv.mkDerivation rec {
        pname = "ublock-origin";
        version = "1.68.0";
        src = pkgs.fetchurl {
          url = "https://github.com/gorhill/uBlock/releases/download/${version}/uBlock0_${version}.chromium.zip";
          hash = "sha256-lpb7CN2QbnH10gD+EH7YUptQMri1kLTUz0nTvxMgEOM=";
        };
        nativeBuildInputs = [ pkgs.unzip ];
        unpackPhase = "unzip $src -d .";
        installPhase = "mkdir -p $out; cp -r uBlock0.chromium/* $out/";
      };
    };
  
    sponsorblock = fetchExtension {
      id = "mnjggcdmjocbbbhaepdhchncahnbgone";
      version = "6.1.2";
      hash = "sha256-Nnud/gWl8DVIUa4g4oDYklDZclQRklHl5Uxvh/aEPYQ=";
    };

    untrap = fetchExtension {
      id = "enboaomnljigfhfjfoalacienlhjlfil";
      version = "9.3.7";
      hash = "sha256-606Xbwjq9c53i/cMsIwOfnDBp0Mf8Ogds6ppEw5lEy0=";
    };
  };

  windowUserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36";

  trustedOrigins = "http://vscode.home:4444,http://mpf2k.home:5173,http://qbittorrent.lab:8080";

  commonArgs = [
    "--test-type"
    "--unsafely-treat-insecure-origin-as-secure=${trustedOrigins}"
    "--load-extension=${extensions.ublock-origin.drv},${extensions.untrap.drv},${extensions.sponsorblock.drv}"
    "--extension-mime-request-handling=always-prompt-for-install"
    "--no-default-browser-check"
    "--restore-last-session"
    "--force-dark-mode"
    "--hide-scrollbars"
    "--hide-fullscreen-exit-ui"
    "--user-agent=\"${windowUserAgent}\""
    "--disable-features=BlockInsecurePrivateNetworkRequests"
    "--disable-features=WaylandWpColorManagerV1"
    "--force-color-profile=srgb"
  ];

  chromiumWrapper = pkgs.writeShellScriptBin "chromium-browser" ''
    exec ${pkgs.ungoogled-chromium}/bin/chromium \
      ${lib.strings.escapeShellArgs commonArgs} \
      "$@" >/dev/null 2>&1
  '';

in

{

  options.my.chromium.wrapper = lib.mkOption {
    type = lib.types.package;
    default = chromiumWrapper;
    description = "Wrapped Chromium package with default flags applied";
  };

  config = {
    home-manager.users.${username} = {
      programs.chromium = {
        enable = true;
        package = pkgs.ungoogled-chromium;
        commandLineArgs = commonArgs; 
      };
      
      home.packages = [ ];
    };
  };

}
