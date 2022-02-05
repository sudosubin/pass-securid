{
  description = "sudosubin/pass-securid";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      pass-securid-overlay = (final: { lib, stdenv, stoken, ... }@prev: {
        pass-securid = stdenv.mkDerivation rec {
          pname = "pass-securid";
          version = "0.1.0";

          src = ./.;

          buildInputs = [ stoken ];
          dontBuild = true;

          installFlags = [
            "PREFIX=$(out)"
            "BASH_COMPLETION_DIR=$(out)/share/bash-completion/completions"
          ];

          meta = with lib; {
            description = "A pass extension for managing RSA SecurIDs";
            homepage = "https://github.com/sudosubin/pass-securid";
            platforms = platforms.unix;
            license = licenses.gpl3Plus;
            maintainers = with maintainers; [ sudosubin ];
          };
        };
      });
    in
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ pass-securid-overlay ];
          };
        in
        {
          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              (pass.withExtensions (exts: [ pass-securid ]))
              stoken
            ];
          };
        }
      );
}
