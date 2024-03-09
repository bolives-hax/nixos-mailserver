{ buildGo117Module, fetchFromGitHub, lib }:
buildGo117Module rec {
  pname = "xapsd";
  version = "f6d57333033694aabef7949de203527d7613aab5";

  src = fetchFromGitHub rec{
    owner = "freswa";
    repo = "dovecot-xaps-daemon";
    rev = version;
    hash = "sha256-D5EefsaRydxcpdsS7ibvx5fEX29sCShI+IOXltyL5RQ=";
  };
  vendorSha256 = "cbMtVH0p1Nlczv0o9wRdNTylY46TQfBCznHDLaf286I=";
  proxyVendor = true; # XXX don't know why I need this to get a successful build
}
