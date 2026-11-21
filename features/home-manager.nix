{ inputs, lib, self, ... }:

{
  flake.nixosModules.home-manager = { id, config, ... }:
    let
      flakeRoot = toString self;

      resolve = src:
        if builtins.isPath src then
          "${id.repoPath}${lib.removePrefix flakeRoot (toString src)}"
        else if lib.hasPrefix "/" src then
          src
        else
          "${id.repoPath}/${src}";

      linkModule = { config, ... }: {
        options.link = lib.mkOption {
          type = lib.types.attrsOf (lib.types.either lib.types.path lib.types.str);
          default = {};
        };

        config.home.file = lib.mapAttrs' (destination: sourcePath:
          lib.nameValuePair destination {
            source = config.lib.file.mkOutOfStoreSymlink (resolve sourcePath);
          }
        ) config.link;
      };
    in
    {
      imports = [ inputs.home-manager.nixosModules.default ];

      options.hm = lib.mkOption {
        type = lib.types.deferredModule;
        default = {};
      };

      config = {
        home-manager = {
          backupFileExtension = "backup";
          extraSpecialArgs = { inherit inputs id; };
          users.${id.user} = {
            home.stateVersion = "25.05";
            imports = [ config.hm linkModule ];
          };
        };
      };
    };
}
