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

default['failover_wordpress']['database']['app_pass'] = 'wordpress'
default['failover_wordpress']['database']['app_user'] = 'wordpress'
# Must be set to the current db server's host
default['failover_wordpress']['database']['host'] = '127.0.0.1'
default['failover_wordpress']['database']['instance_name'] = 'default'
# The values for log_file and log_pos are what repeatedly appeared after bringing up the master
default['failover_wordpress']['database']['log_file'] = 'mysql-bin.000001'
default['failover_wordpress']['database']['log_pos'] = '107'
# Must be specified on db slaves and never on a db master server
default['failover_wordpress']['database']['master_host'] = nil
default['failover_wordpress']['database']['name'] = 'wordpress'
default['failover_wordpress']['database']['root_password'] = 'changeme'
# Options are mysql or percona
default['failover_wordpress']['database']['server'] = 'percona'
# Must be different on every db server
default['failover_wordpress']['database']['server_id'] = '1'
# Must be specified on any db server that may become a master
default['failover_wordpress']['database']['slave_host'] = nil
default['failover_wordpress']['database']['slave_pass'] = 'slave'
default['failover_wordpress']['database']['slave_user'] = 'slave'

# Options are nginx or apache
default['failover_wordpress']['webserver']['server'] = 'nginx'
# Must be specified on db instances
default['failover_wordpress']['webserver']['host'] = '127.0.0.1'

db = node['failover_wordpress']['database']

# Overrides for wordpress ckbk
include_attribute 'wordpress'

# Must be set to master db server
default['wordpress']['db']['host'] = db['host']
default['wordpress']['db']['instance_name'] = db['instance_name']
default['wordpress']['db']['name'] = db['name']
default['wordpress']['db']['user'] = db['app_user']
default['wordpress']['db']['pass'] = db['app_pass']
