{ config, inputs, ... }:
{
  imports = [
    inputs.srvos.nixosModules.mixins-nginx
    inputs.srvos.nixosModules.hardware-hetzner-online-amd
    inputs.self.nixosModules.common
    inputs.self.nixosModules.disko-zfs
    inputs.self.nixosModules.buildbot
    inputs.self.nixosModules.builder
    inputs.self.nixosModules.hercules-ci
    inputs.self.nixosModules.watch-store
    ./builders.nix

    inputs.self.nixosModules.github-org-backup
    inputs.self.nixosModules.hydra
    inputs.self.nixosModules.nur-update
    ./postgresql.nix
  ];

  # the default zpool import services somehow times out while this import works fine?
  boot.initrd.systemd.services.zfs-import-zroot.serviceConfig.ExecStartPre = "${config.boot.zfs.package}/bin/zpool import -N -f zroot";

  nixCommunity.gc.gbFree = 500;

  systemd.network.networks."10-uplink".networkConfig.Address = "2a01:4f8:2190:2698::2";

  networking.hostName = "build03";

  system.stateVersion = "23.11";
}
