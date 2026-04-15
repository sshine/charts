{ inputs, ... }:
{
  imports = [ inputs.devshell.flakeModule ];

  perSystem = { pkgs, system, ... }: {
    devshells.default = {
      packages = [
        pkgs.kubernetes-helm
        inputs.helm-vendor.packages.${system}.default
      ];
    };
  };
}
