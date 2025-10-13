{ inputs, config, pkgs, system, host, username, ... }:

{
  programs.zsh.enable = true;
  users.users.anatou.shell = pkgs.zsh;
}