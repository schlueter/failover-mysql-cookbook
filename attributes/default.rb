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

default['failover-mysql']['database']['app_pass'] = 'wordpress'
default['failover-mysql']['database']['app_user'] = 'wordpress'
# Must be set to the current db server's host
default['failover-mysql']['database']['host'] = '127.0.0.1'
default['failover-mysql']['database']['instance_name'] = 'default'
# The values for log_file and log_pos are what repeatedly appeared after bringing up the master
default['failover-mysql']['database']['log_file'] = nil
default['failover-mysql']['database']['log_pos'] = nil
# Must be specified on db slaves and never on a db master server
default['failover-mysql']['database']['master_host'] = nil
default['failover-mysql']['database']['name'] = 'wordpress'
default['failover-mysql']['database']['root_password'] = 'changeme'
# Options are mysql or percona
default['failover-mysql']['database']['server'] = 'percona'
# Must be different on every db server
default['failover-mysql']['database']['server_id'] = '1'
# Must be specified on any db server that may become a master
default['failover-mysql']['database']['slave_host'] = nil
default['failover-mysql']['database']['slave_pass'] = 'slave'
default['failover-mysql']['database']['slave_user'] = 'slave'

# Options are nginx or apache
default['failover-mysql']['web']['server'] = 'nginx'
# Must be specified on db instances
default['failover-mysql']['web']['host'] = '127.0.0.1'

# Nginx configuration options not provided by the wordpress ckbk
default['failover-mysql']['nginx']['conf']['options'] = {}
default['failover-mysql']['nginx']['conf']['events_options'] = {}

db = node['failover-mysql']['database']

# Overrides for wordpress ckbk
include_attribute 'wordpress'

# Must be set to master db server
default['wordpress']['db']['host'] = db['host']
default['wordpress']['db']['instance_name'] = db['instance_name']
default['wordpress']['db']['name'] = db['name']
default['wordpress']['db']['user'] = db['app_user']
default['wordpress']['db']['pass'] = db['app_pass']
