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

# Options are mysql or percona
default['failover_wordpress']['database']['server'] = 'percona'

default['failover_wordpress']['database']['master']['host'] = '127.0.0.1'
default['failover_wordpress']['database']['master']['instance_name'] = 'default'
default['failover_wordpress']['database']['master']['name'] = 'wordpress'
default['failover_wordpress']['database']['master']['root_password'] = 'changeme'
default['failover_wordpress']['database']['master']['server_id'] = '1'
default['failover_wordpress']['database']['master']['app_user'] = 'wordpress'
default['failover_wordpress']['database']['master']['app_pass'] = 'wordpress'
default['failover_wordpress']['database']['master']['slave_user'] = 'slave'
default['failover_wordpress']['database']['master']['slave_pass'] = 'slave'
# the values for log_file and log_pos are what repeatedly appeared after bringing up the master
default['failover_wordpress']['database']['master']['log_file'] = 'mysql-bin.000001'
default['failover_wordpress']['database']['master']['log_pos'] = '107'

default['failover_wordpress']['database']['slave']['host'] = nil
default['failover_wordpress']['database']['slave']['instance_name'] = 'default'
default['failover_wordpress']['database']['slave']['name'] = 'wordpress'
default['failover_wordpress']['database']['slave']['root_password'] = 'changeme'
default['failover_wordpress']['database']['slave']['server_id'] = '2'

# Options are nginx or apache
default['failover_wordpress']['webserver']['server'] = 'nginx'
default['failover_wordpress']['webserver']['host'] = '127.0.0.1'

primary_db = node['failover_wordpress']['database']['master']

include_attribute 'wordpress'

default['wordpress']['db']['host'] = primary_db['host']
default['wordpress']['db']['instance_name'] = primary_db['instance_name']
default['wordpress']['db']['name'] = primary_db['name']
default['wordpress']['db']['user'] = primary_db['app_user']
default['wordpress']['db']['pass'] = primary_db['app_pass']
