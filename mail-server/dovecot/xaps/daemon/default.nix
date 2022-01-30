{ buildGoModule, fetchFromGitHub, lib }:
buildGoModule rec {
  pname = "xapsd";
  version = "4ae4ab0c0e7faaafebf6d27f0bb028e22e857c02";

  src = fetchFromGitHub rec{
    owner = "freswa";
    repo = "dovecot-xaps-daemon";
    rev = version;
    sha256 = "10sclfjc6aynrl20ky1f2c65d9rjk9midyqqfz11carj7ix2dk8f";
  };
  vendorSha256 = "1sm78q4vimsyw5x0ad1h9r2vi2l7i240k5apph5inllsvwmb5m84";
}
