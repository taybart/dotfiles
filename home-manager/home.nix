{ config, pkgs, ... }:
{
  home = {
    username = "taylor";
    homeDirectory = "/home/taylor";
    stateVersion = "23.05";
  };
  programs.home-manager.enable = true;

  imports = [
    ./modules
  ];
}
