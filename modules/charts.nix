{ self, lib, ... }:
let
  chartsDir = self + "/charts";
  entries = builtins.readDir chartsDir;
  chartPaths = lib.filterAttrs (
    name: type:
    type == "directory" && builtins.pathExists (chartsDir + "/${name}/Chart.yaml")
  ) entries;
in
{
  flake.charts = lib.mapAttrs (name: _: chartsDir + "/${name}") chartPaths;
}
