{ inputs, ... }:
{
  perSystem = { system, ... }: {
    packages.default = inputs.helm-vendor.packages.${system}.default;

    apps.default = inputs.helm-vendor.apps.${system}.default;
  };
}
