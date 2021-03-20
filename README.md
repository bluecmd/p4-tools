# P4 Tools

[![Docker Repository on Quay](https://quay.io/repository/bluecmd/p4-tools/status "Docker Repository on Quay")](https://quay.io/repository/bluecmd/p4-tools)

## BMv2 Simple Switch

The binary `simple_switch` is the Behavioral Model v2 (BMv2) implementation of a P4 switch.
It is statically compiled and availabe under /opt/p4c/simple_switch

### CLI utility

You might need the `simple_switch_CLI` - it can be installed using
`pip3 install p4-simple-switch-cli`.

## P4C

The P4C compiler cannot right now be compiled with Musl. Instead, use
https://hub.docker.com/r/p4lang/p4c.
