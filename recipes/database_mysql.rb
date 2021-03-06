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

db = node['failover-mysql']['database']

is_slave = true unless db['master_host'].nil?

mysql_connection_info = {
  host: db['host'],
  username: 'root',
  password: db['root_password']
}

master_mysql_connection_info = {
  host: db['master_host'],
  username: db['slave_user'],
  password: db['slave_pass']
}

if db['failover']

  log "connection #{mysql_connection_info}"
  log "slave_connection #{master_mysql_connection_info}"
  log "slave_clients #{db['slaves']}"

  mysql_database "#{db['name']}" do
    connection mysql_connection_info
    slave_connection master_mysql_connection_info
    slave_clients db['slaves']
    action :promote
  end
else
  mysql_service db['instance_name'] do
    version '5.5'
    bind_address db['host']
    initial_root_password db['root_password']
    action [:create, :start]
  end

  mysql_config db['instance_name'] do
    source 'mysite.cnf.erb'
    notifies :restart, 'mysql_service[default]'
    variables(
      server_id: db['server_id'],
      host: db['host']
    )
    action :create
  end

  socket = "/var/run/mysql-#{db['instance_name']}/mysqld.sock"

  link '/var/run/mysqld/mysqld.sock' do
    to socket
    not_if 'test -f /var/run/mysqld/mysqld.sock'
  end

  # Used by database resources below
  mysql2_chef_gem 'default' do
    action :install
  end

  # This:
  # mysql> GRANT REPLICATION CLIENT ON *.* TO 'slave'@'192.168.10.12';
  # then get the log file name:
  # mysql -h 192.168.10.11 -uslave -pslave -e "show master status" -s | tail -n 1 | awk {'print $1'}
  # and log pos:
  # mysql -h 192.168.10.11 -uslave -pslave -e "show master status" -s | tail -n 1 | awk {'print $2'}
  if is_slave
    mysql_database "#{db['name']}" do
      connection master_mysql_connection_info
      slave_connection mysql_connection_info
      action :slave
    end
  end

  mysql_database db['name'] do
    connection mysql_connection_info
    action :create
  end

  mysql_database_user db['app_user'] do
    connection mysql_connection_info
    password db['app_pass']
    database_name db['name']
    host node['failover-mysql']['web']['host']
    privileges [:all]
    action [:create, :grant]
  end

  mysql_database_user db['slave_user'] do
    connection mysql_connection_info
    password db['slave_pass']
    host db['slave_host']
    privileges ['REPLICATION SLAVE', 'REPLICATION CLIENT']
    action [:create, :grant]
  end
end
