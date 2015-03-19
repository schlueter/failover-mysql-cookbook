# Failover <s>Wordpress</s> MySQL 

This cookbook provides recipes, and additional actions for the mysql_database resource, to allow failover [MySQL][] configurations to be easily created and fail-over triggered. An example recipe for a [Wordpress][] site which can be used to point it at a promoted master is also included.

## Example

The Vagrantfile can be used to bring up an example [Virtual box][] instance hosted via [Vagrant][]. The default database is Oracle's vanilla [MySQL][] and Wordpress is served by [Nginx][].

### Dependencies

- [Chef Development Kit][]
- [Vagrant][]
- [Vagrant Berkshelf][], obtainable by `vagrant plugin install vagrant-berkshelf`
- [Vagrant Omnibus][], obtainable by `vagrant plugin install vagrant-omnibus`

#### Optional

- [Vagrant Cachier][], obtainable by `vagrant plugin install vagrant-cachier`

### Bringing it up

Run `vagrant up` in the root of this project to bring up 3 instances: `web`, which hosts the [Wordpress][] site; `sql1`, a [MySQL][] server initially configured as master; and `sql2`, a second MySQL server initially configured as a slave to he master.

#### Failover

Fail over can be initiated by running `FAILOVER=1 vagrant provision` after the servers have been brought up. This command can be run repeatedly to switch which of the `sql1` and `sql2` instances is the master database server. 

## Actions added to `mysql_database`

- :slave: configure a server as a slave to another
    uses new property `slave_connection`
- :promote: promote a slave server to master and slave its previous master to it
    Uses new property `slaves` which should be an array of hashes containing connection information for each slave which will not be promoted to master and the current master. Additionally, the `slave_connection` property should be populated with connection information for a slave user on the new master, and the `connection` property should be connection information for a user with the __SUPER__ privilege on the new master. 

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
