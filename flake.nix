{
  description = "Dev environment for zigging";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    # 0.15.2
    zig-nixpkgs.url = "github:NixOS/nixpkgs/117cc7f94e8072499b0a7aa4c52084fa4e11cc9b";
  };

  outputs =
    {
      self,
      flake-utils,
      zig-nixpkgs,
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        zig-nixpkgs = inputs.zig-nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = zig-nixpkgs.mkShell {
          packages = [
            zig-nixpkgs.zig
          ];

          shellHook = ''
            echo "zig" "$(zig version)"
          '';
        };
      }
    );
}
