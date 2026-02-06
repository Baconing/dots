{ lib, kubenix }:

{ module }:

let
  userConfig =
    if builtins.isPath module then import module else module;

  moduleDirs =
    builtins.filter
      (n: n != "default.nix")
      (builtins.attrNames (builtins.readDir ./.));

  serviceModules =
    map (n: ./${n}) moduleDirs;
in
{
  imports = serviceModules;

  config = userConfig;
}