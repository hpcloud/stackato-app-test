stackato-apps-test
==================

This repo contains a system for testing all the known Stackato apps against a
Stackato setup.

## Examples

    ./bin/test-apps --help

    ./bin/test-apps --list

    ./bin/test-apps --list --tag=FAIL

    ./bin/test-apps --tag=ruby

    ./bin/test-apps env go-env

    ./bin/test-apps --first=hastebin

    ./bin/test-apps --after=jenkins

