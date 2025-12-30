{ inputs, ... }:

{
  services.xremap = {
    enable = true;
    withHypr = true;

    yamlConfig = ''
      keymap:
        - name: Global Launch Trigger
          remap:
            Super-l:
              remap:
                v:
                  launch: ["foot", "-e", "nvim"]
              timeout_millis: 500
    '';

    watch = true;
  };
}
