# IDC development platform

Leverages ISLE to provide a local development environment for the IDC stack, with particular focus on development/testing of 
the Drupal site.

## Quickstart

    cd local
    ./init.sh

This initializes a development environment in the `local` directory.  In particular, it does the following

* Downloads our Drupal site (set in `/local/repos.conf`) into the `codebase` directory so that ISLE can run it, and we can develop against it
* Downloads the ISLE development suite
* Uses the ISLE `Makefile` to build a local-development-specific `docker-compose.yml`, launches it, and installs the Drupal site in `codebase` 

Once complete, the Islandora stack will be running.  Drupal is accessible at:

https://islandora-idc.traefik.me/


Look at docker-compose.env.yml for passwords, but the default password for Drupal is `admin:password`.

## Configuration

### Development Platform configuration

`local/repos.conf` contains the git repos and branches of ISLE and the drupal codebase that `init.sh` will download when initializing the platform.

### ISLE configuration

See the [isle-dc documentation](https://github.com/Islandora-Devops/isle-dc/blob/development/README.md) for full details.

`local/.env` defines environment variables that influence ISLE's Makefile and docker-compose.yml generation/execution.  Notably, it 
defines the list of services that will be run as part of the islandora stack.  This project diverges from ISLE defaults in that Fedora
and Blazegraph are excluded (as per the `REQUIRED_SERVICES` variable in `.env`).

`local/docker-compose.env.yml` defines container-specific environment variables.  For example, the Drupal username and password.

Both files are committed/maintained in _this_ repository, so that all developers who checkout this project launch ISLE in a uniform way.

## Development notes

Development takes place in the `local` directory.

To start from scratch at any time and/or pull in updates from ISLE or our Drupal codebase, run `init.sh`.  See [quickstart](#Quickstart).

Changes to the ISLE configuration (`.env`, `docker-compose.env.yml`) are under source control and tested/committed as necessary.

### Drupal development

Because the `codebase` directory is a checked-out git repository of our Drupal site, git commands from within the `codebase` directory operate against _the chceked out Drupal site_ (which is defined in `repos.conf`).  so you can just commit and push changes in this directory, and 
they'll go to the right place.

The Drupal site/s configuration is under source control (in `codebase/config/sync`), so changes to configuration are expected to be tested, and committed when done.  The ISLE `Makefile` has a convenient command for dumping configuration

    make config-export

This will print a nice message from Drush summarizing config changes.  `git diff` will also show the line-by-line config changes in the various config yaml files.

If you make config changes, you can verify that they work in a created-from-scratch site by running `init.sh` again.