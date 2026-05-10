{ inputs, ... }:
{
  imports = [ inputs.devshell.flakeModule ];

  perSystem = { pkgs, system, ... }: {
    devshells.default = {
      packages = [
        pkgs.just
        pkgs.kubernetes-helm
        inputs.helm-vendor.packages.${system}.default
      ];

      devshell.startup.helm-vendor-completion.text = ''
        if [ -n "$ZSH_VERSION" ]; then
          eval "$(helm-vendor completion zsh)"
        elif [ -n "$BASH_VERSION" ]; then
          eval "$(helm-vendor completion bash)"
        fi
      '';
    };
  };
}
