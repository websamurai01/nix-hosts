{ ... }:

{
  flake.nixosModules.photopea = { ... }: {
    webApps.photopea = {
      name = "Photopea";
      url = "https://www.photopea.com/";
      icon = "photopea";
      browser = "chromium";
    };
  };
}
