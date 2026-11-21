{ ... }:

{
  flake.nixosModules.youtube = { ... }: {
    webApps.youtube = {
      name = "YouTube";
      url = "https://youtube.com";
      icon = "youtube";
      browser = "chromium";
    };
  };
}
