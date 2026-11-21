{ ... }:

{
  flake.nixosModules.figma = { ... }: {
    webApps.figma = {
      name = "Figma";
      url = "https://figma.com";
      icon = "figma";
      browser = "chromium";
    };
  };
}
