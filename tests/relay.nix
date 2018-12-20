#  nixos-mailserver: a simple mail server
#  Copyright (C) 2016-2018  Robin Raymond
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program. If not, see <http://www.gnu.org/licenses/>

import <nixpkgs/nixos/tests/make-test.nix> {

  nodes = let
    mailCommon = {
        enable = true;
        fqdn = "mail.example.com";
        domains = [ "example.com" ];
        rewriteMessageId = true;

        loginAccounts = {
          "user1@example.com" = {
            hashedPassword = "$6$/z4n8AQl6K$kiOkBTWlZfBd7PvF5GsJ8PmPgdZsFGN1jPGZufxxr60PoR0oUsrvzm2oQiflyz5ir9fFJ.d/zKm/NgLXNUsNX/";
            aliases = [ "postmaster@example.com" ];
            catchAll = [ "example.com" ];
          };
        };
      }; in
    {
    base = { config, pkgs, ... }:
      {
        imports = [
          ../default.nix
        ];

        mailserver = mailCommon;
      };
    credentials = { config, pkgs, ... }:
      {
        imports = [
          ../default.nix
        ];

        mailserver = mailCommon // {
          relay = {
            enable = true;
            host = "relay.example.com";
            port = 587;
            credentials = "user@example.com:password";
          };
        };
      };
    };
    
  testScript = 
    ''
    $base->start;
    $base->waitForUnit("multi-user.target");

    $credentials->start;
    $credentials->waitForUnit("postfix");

    subtest "no relay set", sub {
      # check that config did not set a relayhost
      $base->fail("cat /etc/postfix/main.cf | grep 'relayhost'");
    };

    subtest "enables credentials and sets sasl_passwd file", sub {
      # check that adding credentials correctly enables auth in config and creates sasl file
      $credentials->succeed("cat /etc/postfix/main.cf | grep 'smtp_sasl_auth_enable = yes'");
      $credentials->succeed("cat /etc/postfix/main.cf | grep 'smtp_sasl_security_options = noanonymous'");
      $credentials->succeed("cat /etc/postfix/main.cf | grep 'smtp_sasl_password_maps = .'");
      $credentials->succeed("cat /etc/postfix/sasl_passwd | grep 'relay.example.com user\@example.com:password'");
    };
    '';
}

