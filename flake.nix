{
  description = "pass-securid";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
  };

  outputs = { self, nixpkgs }:
    let
      inherit (nixpkgs.lib) genAttrs platforms;
      forAllSystems = f: genAttrs platforms.unix (system: f (import nixpkgs {
        inherit system;
        overlays = [ (final: prev: { pass-securid = final.callPackage ./nix { }; }) ];
      }));

    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            (pass.withExtensions (exts: [ pass-securid ]))
            stoken
          ];
        };
      });
    };
}
