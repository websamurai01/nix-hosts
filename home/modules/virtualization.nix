{ pkgs, inputs, ... }:

{

  virtualisation.containers.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
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

}
