{ fetchFromGitHub, stdenv, cmake, gcc, dovecot, lib, ... }:
let
src = fetchFromGitHub {
  owner = "freswa";
  repo = "dovecot-xaps-plugin";
  rev = "0ca09dc9e245dabc77172175e335ab6d73d7f686";
  sha256 = "1fxnwvvaqc1bp11hy9cvcwgk59266np8mxr063hz2q4xqlivgj7b";
};
in
  stdenv.mkDerivation {
    name = "dovecot-xaps-plugin";
    inherit src;

    nativeBuildInputs = [ cmake gcc dovecot ];

    preConfigure = ''
      export CMAKE_LIBRARY_PATH=${dovecot}/lib/dovecot
      export NIX_CFLAGS_COMPILE=-I${dovecot}/include/dovecot
    '';

    installFlags = [ "DESTDIR=$(out)" ];

    postInstall = ''
      mkdir $out/lib
      mv $out/var/empty/lib/dovecot/modules $out/lib/dovecot
      rm -r $out/var
    '';
  }
