{
  description = "A simple launcher for desktop applications";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachSystem [ "i686-linux" "aarch64-linux" "x86_64-linux" ] (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells = rec {
        default = pkgs.mkShell {
          packages = [ pkgs.dex ];
        };
      };

      packages = rec {
        desktop-entry-launcher = pkgs.writeScriptBin "desktop-entry-launcher" ''
          export PATH="${pkgs.lib.makeBinPath [ pkgs.dex ]}:$PATH"
          ${./desktop-entry-launcher} $@
        '';

        default = desktop-entry-launcher;
      };


      apps = rec {
        desktop-entry-launcher = flake-utils.lib.mkApp {
          drv = self.packages.${system}.desktop-entry-launcher;
        };
        default = desktop-entry-launcher;
      };
    }
  );
}
