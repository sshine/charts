{
  description = "Vendored Helm charts for the k8s cluster";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    import-tree.url = "github:vic/import-tree";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";

    helm-vendor.url = "git+ssh://git@git.shine.town/infra/helm-vendor";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      inputs.import-tree ./nix
      // {
        systems = [ "x86_64-linux" "aarch64-linux" ];
      }
    );
}
