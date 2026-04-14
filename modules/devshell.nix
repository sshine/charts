{ inputs, ... }:
{
  imports = [ inputs.devshell.flakeModule ];

  perSystem = { pkgs, ... }: {
    devshells.default = {
      packages = [
        pkgs.just
        pkgs.kubernetes-helm
        pkgs.python3
      ];
    };
  };
}
