##
#    Copyright (C) 2015 Brandon Schlueter
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
##

name 'failover-mysql'
maintainer 'Brandon Schlueter'
maintainer_email 'bs@bschlueter.com'
license 'GPL v3'
description 'Provides recipes for the wordpress-with-mysql-replication-and-failover projects'
supports 'ubuntu'

version '0.0.1'

depends 'percona-multi'
depends 'database'
depends 'mysql', '~> 6.0'
depends 'nginx'
depends 'wordpress'
