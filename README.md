# Failover <s>Wordpress</s> MySQL 

This cookbook provides recipes, and additional actions for the mysql_database resource, to allow failover [MySQL][] configurations to be easily created and fail-over triggered. An example recipe for a [Wordpress][] site which can be used to point it at a promoted master is also included.

## Example

The Vagrantfile can be used to bring up an example [Virtual box][] instance hosted via [Vagrant][]. The default database is Oracle's vanilla [MySQL][] and Wordpress is served by [Nginx][].

### Bringing it up

Run `vagrant up` in the root of this project to bring up 3 instances: `web`, which hosts the [Wordpress][] site; `sql1`, a [MySQL][] server initially configured as master; and `sql2`, a second MySQL server initially configured as a slave to he master.

#### Failover

Fail over can be initiated by running `FAILOVER=1 vagrant provision` after the servers have been brought up. This command can be run repeatedly to switch which of the `sql1` and `sql2` instances is the master database server. 

## Dependencies

- [Chef Development Kit][]
- [Vagrant][]
- [Vagrant Berkshelf][], obtainable by `vagrant plugin install vagrant-berkshelf`
- [Vagrant Omnibus][], obtainable by `vagrant plugin install vagrant-omnibus`

### Optional

- [Vagrant Cachier][], obtainable by `vagrant plugin install vagrant-cachier`



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
