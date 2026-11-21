{ ... }:

{
  flake.nixosModules.web-apps =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      webApps = config.webApps;

      appType = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Desktop entry name";
            };

            url = lib.mkOption {
              type = lib.types.str;
              description = "URL to open";
            };

            icon = lib.mkOption {
              type = lib.types.nullOr (lib.types.either lib.types.str lib.types.path);
              default = null;
              description = "Icon name or path";
            };

            browser = lib.mkOption {
              type = lib.types.str;
              description = "Browser instance command on PATH, e.g. chromium-lan";
            };

            args = lib.mkOption {
              type = lib.types.nullOr (lib.types.listOf lib.types.str);
              default = null;
              description = "Launcher arguments appended to --app=<url>; null appends none";
            };
          };
        }
      );

      launchArgs = app: [ "--app=${app.url}" ] ++ (if app.args == null then [ ] else app.args);

      # Desktop Entry spec, Exec key: inside double quotes escape " ` $ \ and
      # double % so URLs such as %20 survive.
      quoteArg =
        arg:
        let
          escaped = lib.replaceStrings [ "\\" "\"" "`" "$" "%" ] [ "\\\\" "\\\"" "\\`" "\\$" "%%" ] arg;
        in
        "\"${escaped}\"";

      execLine = app: lib.concatStringsSep " " (map quoteArg (launchArgs app));

      command =
        id: app:
        pkgs.writeShellScriptBin "${id}-web-app" ''
          set -euo pipefail

          if ! command -v ${lib.escapeShellArg app.browser} > /dev/null; then
            echo "webApps.${id}: browser '${app.browser}' not found on PATH" >&2
            exit 127
          fi

          exec ${lib.escapeShellArg app.browser} ${lib.escapeShellArgs (launchArgs app)} "$@"
        '';
    in
    {
      options.webApps = lib.mkOption {
        type = appType;
        default = { };
        description = "Web apps, each launched by the browser instance command it names";
      };

      config = {
        hm = {
          home.packages = lib.mapAttrsToList command webApps;

          xdg.desktopEntries = lib.mapAttrs' (
            id: app:
            lib.nameValuePair id {
              name = app.name;
              icon = if app.icon == null then null else toString app.icon;
              exec = "${quoteArg app.browser} ${execLine app}";
              terminal = false;
              categories = [
                "Network"
                "WebBrowser"
              ];
            }
          ) webApps;
        };
      };
    };
}
