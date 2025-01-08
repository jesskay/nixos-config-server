# NixOS config


This is my NixOS config, plus some tooling for managing its inputs without
flakes.


## Structure of this repo


### `hosts`

Configurations for each host start in `hosts/HOSTNAME/default.nix`. From there,
the configuration can pull in files from other parts of the hierarchy.

Configuration that is strictly only for one host will be in files under
`hosts/HOSTNAME`, while all other configuration should be kept more general.


### `modules`

Modules that extend NixOS's configuration options:

- `simple-nginx` provides options under `services.nginx.simpleVhosts` to
  allow terse definition of a number of types of vhosts with SSL-by-default
  (using ACME certificate provisioning).


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

Shell script and nix file that wrap `nixos-rebuild` in order to determine the
hostname to build for, and to set the `NIX_PATH` appropriately for a
non-channels and non-flake build. The latter part is heavily cribbed from
[this article][jade-pinning], though adapted for not using npins (in favour of
using `builtins.fetchTree`, which npins does not yet support due to its
experimental status).



[agenix]: https://github.com/ryantm/agenix
[freshrss]: https://www.freshrss.org/
[home-assistant]: https://www.home-assistant.io/
[munin]: https://munin-monitoring.org/
[ntfy]: https://ntfy.sh/
[nginx]: https://nginx.org/
[syncthing]: https://syncthing.net/
[tailscale]: https://tailscale.com/
[jade-pinning]: https://jade.fyi/blog/pinning-nixos-with-npins/
