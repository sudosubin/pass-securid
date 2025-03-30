{ lib
, stdenv
, stoken
}:

stdenv.mkDerivation {
  pname = "pass-securid";
  version = "0.1.1";

  src = ./..;

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
}
