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

default['failover_wordpress']['database']['server'] = 'percona'
default['failover_wordpress']['database']['master']['host'] = '127.0.0.1'
default['failover_wordpress']['database']['slave']['host'] = nil
default['failover_wordpress']['database']['master']['initial_root_password'] = 'changeme'

default['failover_wordpress']['webserver']['server'] = 'nginx'

default['failover_wordpress']['wordpress']['name'] = 'my blog'

include_attributes 'wordpress'

default['wordpress']['db']['host'] = node['failover_wordpress']['database']['master']['host']
