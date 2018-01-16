# dockerSymmetricDNSSample

This project aims to demonstrate how to setup a set of services that reachable using DNS resolution, from outside or inside container network.

# Objective

For development purposes I would like to:
1. Be able to reach them by name instead of localhost or IP addresses;
1. They should be reachable by the same name, no matter if requested from Docker network or from host system, and should be portable to Windows;
1. I don't want to touch the system hosts file
1. Be able to use the default ports for services like databases and web;

# Solution overview

To be able to address objective (1) the solution is a proper naming for the services, i.e. using the DNS as the name of the service.

To be able to address objective (2, 3) the solution is a DNS server that must be used by the host system also.

To be able to address objective (4), outside Docker network, the solution is to combine the DNS with a Reverse Proxy.

# Notes

On Windows, by default, you are not able to reach containers by their IP addresses. The workaround I've found is to publish ports
on `127.0.0.2`, so I'm safe to leave `127.0.0.1` alone and can always reach services through the reverse proxy using that IP.

This also solves the problem with the DNS resolution, so we can define a DNS pattern (in this example is *.docker) that points to `127.0.0.2`.

Using the DNS as the name of the service on the compose files allows to use the same address inside Docker network, skipping the resolution
to `127.0.0.2` by our custom DNS server.

# Usage

- `docker-compose up` to start everything
- run `setup-local-dns.ps1` to tell windows to first ask our custom DNS

# Future

- Add a linux DNS setup script
- Test on linux env

