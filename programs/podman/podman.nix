{ ... }:

{
  flake.nixosModules.podman = { ... }: {
    virtualisation.containers.enable = true;

    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };

    virtualisation.containers.containersConf.settings = {
      containers = {
        log_driver = "k8s-file";
      };
      engine = {
        runtime = "crun";
        events_logger = "file";
        cgroup_manager = "systemd";
      };
    };

    hm.link.".config/containers" = ./.config/containers;
  };
}
