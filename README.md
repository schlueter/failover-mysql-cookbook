# Wordpress using a Replicated database with easy fail over

This project is an example of a [Wordpress][] site using a replicated database with single command fail over. This implementation runs [Virtual box][] servers hosted via [Vagrant][]. The default database is [MySQL][] and Wordpress is served by [Nginx][].

## Dependencies

- [Chef Development Kit][]
- [Vagrant][]
- [Vagrant Omnibus][], obtainable by `vagrant plugin install vagrant-omnibus`
- [Vagrant Berkshelf][], obtainable by `vagrant plugin install vagrant-berkshelf`

### Optional

- [Vagrant Cachier][], obtainable by `vagrant plugin install vagrant-cachier`

## Usage

Run `vagrant up` in the root of this project.

### Failover

Fail over can be initiated by running `FAILOVER=1 vagrant provision` after the servers have been brought up. This command can be run repeatedly to switch the master database server. 

## License

Copyright (C) 2015 Brandon Schlueter
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

[Wordpress]: https://wordpress.org/
[Virtual box]: https://www.virtualbox.org/
[Vagrant]: https://www.vagrantup.com/
[MySQL]: http://www.mysql.org/
[Nginx]: http://nginx.org/
[Chef Development Kit]: https://downloads.chef.io/chef-dk/
[Vagrant Omnibus]: https://github.com/chef/vagrant-omnibus
[Vagrant Cachier]: http://fgrehm.viewdocs.io/vagrant-cachier
[Vagrant Berkshelf]: https://github.com/berkshelf/vagrant-berkshelf
