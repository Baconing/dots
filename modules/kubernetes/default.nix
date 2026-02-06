{ lib, kubenix }:

{ module }:

let
  normalizedConfig = if builtins.isPath module then import module else module;

  moduleDirs =
    builtins.filter
      (n: n != "default.nix")
      (builtins.attrNames (builtins.readDir ./.));

  modules = map (n: ./${n}) moduleDirs;

  eval = lib.evalModules { 
    modules = modules ++ [ kubenix.modules.k8s ];
    specialArgs = { inherit kubenix; };
    args = { config = normalizedConfig; };
  };
in
{
  inherit (eval) config options;

  imports = [ kubenix.modules.k8s ];
  
  config.kubernetes = eval.kubernetes;
}