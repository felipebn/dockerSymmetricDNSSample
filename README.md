# dockerSymmetricDNSSample

This project aims to demonstrate how to setup a set of services that are reachable using DNS resolution, from outside or inside container network.

# Motivation

For development purposes I would like to:
1. Be able to reach services by name instead of `localhost` or IP addresses;
1. They should be reachable by the same name, no matter if requested from Docker network or from host system, and should be portable to Windows;
1. I don't want to touch the system hosts file
1. Be able to use the default ports for services like databases and web;

# Solution overview

To be able to address objectives (1) the solution is a proper naming for the services, i.e. using the desired DNS as the name of the service.

To be able to address objectives (2, 3) the solution is a DNS server that must be used by the host system also.

To be able to address objectives (4), outside Docker network, the solution is to combine the DNS with a Reverse Proxy.

# Reverse HTTP Proxy and TCP

The HTTP protocol is well suited to reverse proxying as the protocol carries the hostname in the message header.

For TCP we do not have the same lucky, then we may use the `127.0.0.*` addresses to expose multiple services, with the same port on the host and applying name resolution.

Currently this is done manually by including hosts in the `dnsmasq` command line but it could be automated using [docker-gen](https://github.com/jwilder/docker-gen).

# Notes

On Windows, by default, you are not able to reach containers by their IP addresses. 

The workaround I've found is to publish ports
on `127.0.0.2`, so we leave `127.0.0.1` alone and can always reach services through the reverse proxy/publish using those IPs.

Using the DNS as the name of the service on the compose files allows to use the same address inside Docker network, skipping the resolution to `127.0.0.2` by our custom DNS server.

# Usage

- Run `docker-compose up` to start everything
- Run `setup-local-dns.ps1` to tell Windows to ask our custom DNS
- Try pinging `other.docker` and `whoami.docker`, they should resolve to `127.0.0.2`
- Try pinging `postgresql.docker`, it should resolve to `127.0.0.4`
- You can try `http://other.docker` and `http://whoami.docker` from your browser as well
- You can try log in into `postgresql.docker`
- Try `docker exec -i -t internal_testing_box ping whoami.docker -c 4`, it should resolve to some Docker network IP

# Port Conflicts

If you receive errors while docker tries to bind some ports, could be that you already have some local service binded to it.

Example: you already have a local postgresql server running.

In this case you will need to change the address where your local (i.e. host) services bind to. 

PostgreSQL for example binds to `*` initially, which means all addresses, changing it to `127.0.0.1`
allows it to answer to `localhost` still and does not conflicts with `127.0.0.2:5432`.

# Future

- Automate the `dnsmasq` config generation
- Add a linux DNS setup script
- Test on linux env


