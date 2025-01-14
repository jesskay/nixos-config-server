# NixOS config


This is my NixOS config, plus some tooling for managing its inputs without
flakes.


## Structure of this repo


### `hosts`

Definitions for hosts are found in `hosts/default.nix`, with a few fields:

- `system`: _(required)_ The system (e.g., x86\_64-linux, aarch64-darwin, ...)
  the host runs on.

- `config`: _(required)_ The base module of the host's configuration. By
  convention, this is typically `hosts/HOSTNAME/default.nix`, but it doesn't
  have to be.

- `nixpkgs`: _(required)_ A nixpkgs source that the host's config will be built
  against. This uses `sources` (see below) to get the path to a nixpkgs source
  tree, and then the build will combine this with the host's `system` and
  `overlays` to instantiate the nixpkgs used to go on and build the system.

- `overlays`: _(optional)_ A list of overlays to apply to nixpkgs when building
  this host.


### `modules`

Modules that extend NixOS's configuration options:

- `simple-nginx` provides options under `services.nginx.simpleVhosts` to
  allow terse definition of a number of types of vhosts with SSL-by-default
  (using ACME certificate provisioning).


### `overlays`

Overlays to be applied to nixpkgs. One overlay per nix file, defined directly
at the top level of that file.


### `nix`

Configuration for Nix itself. At time of writing, it configures automatic
garbage collection and trusted users for substituters, and enables flake
support in Nix tooling, including creating entries in the flake registry
for the nixpkgs inputs used to build the system.


### `programs`

Configuration for programs that need more than simply having their packages
added to the user environment:

- `neovim`

- `starship`

- `tmux`


### `secrets`

Secrets used by various modules, encrypted using [agenix][agenix].


### `services`

Configuration for services:

- [Calibre-Web][calibre-web]

- [FreshRSS][freshrss] plus extensions

- [Home Assistant][home-assistant] in a podman container

- [Munin][munin]

- [ntfy.sh][ntfy]

- Static sites served by [nginx][nginx]

- [Syncthing][syncthing]

- [Tailscale][tailscale]


### `users`

Configuration for users:

- `jess`


### `sources.json` and `sources.nix`

Sources for the inputs used to build configurations. The tooling updates data
in the JSON file, and `sources.nix` imports that data and uses
`builtins.fetchTree` to retrieve the referenced sources.


### `sources.sh`

Simple shell script to manage `sources.json`. Currently only supports git
sources, though I do want to expand it to support `builtins.fetchTree`'s other
source types eventually.


### `build.sh` and `build.nix`

Shell script and nix file that wrap `switch-to-configuration`, providing a less
featureful but lighter alternative to `nixos-rebuild`. They build and optionally
activate the configuration defined in `hosts` for a given hostname (by default,
the current hostname of the system they're running on).



[agenix]: https://github.com/ryantm/agenix
[calibre-web]: https://github.com/janeczku/calibre-web
[freshrss]: https://www.freshrss.org/
[home-assistant]: https://www.home-assistant.io/
[munin]: https://munin-monitoring.org/
[ntfy]: https://ntfy.sh/
[nginx]: https://nginx.org/
[syncthing]: https://syncthing.net/
[tailscale]: https://tailscale.com/
[jade-pinning]: https://jade.fyi/blog/pinning-nixos-with-npins/
