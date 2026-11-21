{ inputs, ... }:

{
  flake.nixosModules.chromium =
    { pkgs, lib, ... }:
    let
      extensions = inputs.ungoogled.lib.mkExtensions {
        inherit pkgs lib;

        settings = {
          ublock-origin = import ./ublock-origin/_settings.nix;
          sponsorblock = {
            alreadyInstalled = true;
          };
        };
      };
    in
    {
      chromium = {
        enable = true;

        baseArgs = [
          "--test-type"
          "--extension-mime-request-handling=always-prompt-for-install"
          "--no-default-browser-check"
          "--restore-last-session"
          "--force-dark-mode"
          "--hide-scrollbars"
          "--hide-fullscreen-exit-ui"
          "--force-color-profile=srgb"
          "--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"
        ];

        trustedOrigins = [
          "http://vscode.home:4444"
          "http://mpf2k.home:5173"
          "http://qbittorrent.lab:8080"
        ];

        disableFeatures = [
          "BlockInsecurePrivateNetworkRequests"
          "WaylandWpColorManagerV1"
        ];

        instances.default = {
          extensions = [
            extensions.ublock-origin
            extensions.sponsorblock
            extensions.youtube-theater
          ];
          backgroundService = true;
          serviceEnvironment = [ "XDG_CURRENT_DESKTOP=Hyprland" ];
        };
      };
    };
}
