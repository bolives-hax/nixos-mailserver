Contribute or troubleshoot
==========================

To report an issue, please go to
`<https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/issues>`_.

You can also chat with us on the Libera IRC channel ``#nixos-mailserver``.

Run NixOS tests
---------------

To run the test suite, you need to enable `Nix Flakes
<https://nixos.wiki/wiki/Flakes#Installing_flakes>`.

You can then run the testsuite via

::

   $ nix flake check -L

Since Nix doesn't garantee your machine have enough resources to run
all test VMs in parallel, some tests can fail. You would then haev to
run tests manually. For instance:

::

   $ nix build .#hydraJobs.x86_64-linux.external-unstable -L


Contributing to the documentation
---------------------------------

The documentation is written in RST, build with Sphinx and published
by `Read the Docs <https://readthedocs.org/>`_.

For the syntax, see `RST/Sphinx Cheatsheet
<https://sphinx-tutorial.readthedocs.io/cheatsheet/>`_.

The ``shell.nix`` provides all the tooling required to build the
documentation:

::

   $ nix-shell
   $ cd docs
   $ make html
   $ firefox ./_build/html/index.html

Note if you modify some NixOS mailserver options, you would also need
to regenerate the ``options.rst`` file:

::

   $ nix-shell --run generate-rst-options

Nixops
------

You can test the setup via ``nixops``. After installation, do

::

   $ nixops create nixops/single-server.nix nixops/vbox.nix -d mail
   $ nixops deploy -d mail
   $ nixops info -d mail

You can then test the server via e.g. \ ``telnet``. To log into it, use

::

   $ nixops ssh -d mail mailserver

Imap
----

To test imap manually use

::

   $ openssl s_client -host mail.example.com -port 143 -starttls imap

opendkim
--------

to debug opendkim filtering (if you get errors like: ``Dec 11 18:35:51 mail opendkim[1454]: 9C4D771121A: no signing table match for ...``
you can do something like:
.. code:: shell

    opendkim -Q

Then at the prompt type:

.. code:: shell

    refile:/etc/opendkim/SigningTable
    test@mydomain.com/1

You should get back "mydomain.com". CTRL-D to exit.

To debug opendkim keytable matching:

.. code:: shell

    opendkim -Q

Then:

.. code:: shell

    refile:/etc/opendkim/KeyTable
    mydomain.com/3

you should get back 3 lines, the 1st is the domain to match, the 2nd is the selector and the 3rd is the keyfile to use. If you don't your keytable is incorrect.)
