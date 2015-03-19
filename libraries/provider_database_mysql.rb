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

class Chef
  class Provider
    class Database
      # Augment Provider::Database::Mysql defined in database ckbk
      class Mysql < Chef::Provider::LWRPBase
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :slave do
          converge_by "Querying master '#{new_resource.database_name}' for log properties" do
            begin
              master_sql = 'SHOW MASTER STATUS'
              Chef::Log.debug("Performing query [#{master_sql}]")
              master_result = master_client.query(master_sql)
              master_result.each do |result|
                Chef::Log.info("Retrieved log file name #{result['File']} from master")
                @log_file = result['File']
                Chef::Log.info("Retrieved log file position #{result['Position']} from master")
                @log_pos = result['Position']
              end
            ensure
              close_master_client
            end
          end

          converge_by "Setting master on slave '#{new_resource.database_name}'" do
            begin
              slave_sql = 'CHANGE MASTER TO'
              slave_sql += " MASTER_HOST='#{new_resource.connection[:host]}',"
              slave_sql += " MASTER_USER='#{new_resource.connection[:username]}',"
              slave_sql += " MASTER_PASSWORD='#{new_resource.connection[:password]}',"
              slave_sql += " MASTER_LOG_FILE='#{@log_file}',"
              slave_sql += " MASTER_LOG_POS=#{@log_pos}"
              Chef::Log.debug("Performing query [#{slave_sql}]")
              slave_client.query(slave_sql)
            ensure
              close_slave_client
            end
          end
        end

        action :promote do
          # From the MySQL docs at http://dev.mysql.com/doc/refman/5.5/en/replication-solutions-switch.html:
          #
          # "Make sure that all slaves have processed any statements in their relay log. On each
          # slave, issue STOP SLAVE IO_THREAD, then check the output of SHOW PROCESSLIST until you
          # see [Has read all relay log] SIC?. When this is true for all slaves, they can be
          # reconfigured to the new setup. On the slave Slave 1 being promoted to become the
          # master, issue STOP SLAVE and RESET MASTER.
          #
          # On the other slaves Slave 2 and Slave 3, use STOP SLAVE and CHANGE MASTER TO
          # MASTER_HOST='Slave1' (where 'Slave1' represents the real host name of Slave 1). To use
          # CHANGE MASTER TO, add all information about how to connect to Slave 1 from Slave 2 or
          # Slave 3 (user, password, port). When issuing the CHANGE MASTER TO statement in this,
          # there is no need to specify the name of the Slave 1 binary log file or log position to
          # read from, since the first binary log file and position 4, are the defaults. Finally,
          # execute START SLAVE on Slave 2 and Slave 3."
          converge_by 'Halting slaves' do
            begin
              slave_sql = 'STOP SLAVE IO_THREAD'
              slave_clients.each do |slave|
                Chef::Log.debug("Performing query [#{slave_sql}]")
                slave.query(slave_sql)
              end
            ensure
              close_slave_clients
            end
          end

          converge_by "Resetting master on slave '#{new_resource.database_name}'" do
            begin
              master_sql = 'STOP SLAVE'
              master_client.query(master_sql)
              master_sql = 'RESET MASTER'
              master_client.query(master_sql)
              Chef::Log.debug("Performing query [#{master_sql}]")
            ensure
              close_master_client
            end
          end

          converge_by 'Setting new master on slaves' do
            begin
              slave_sql = 'STOP SLAVE'
              slave_clients.each do |slave|
                Chef::Log.debug("Performing query [#{slave_sql}]")
                slave.query(slave_sql)
              end
              slave_sql = 'CHANGE MASTER TO'
              slave_sql += " MASTER_HOST='#{new_resource.slave_connection[:host]}',"
              slave_sql += " MASTER_USER='#{new_resource.slave_connection[:username]}',"
              slave_sql += " MASTER_PASSWORD='#{new_resource.slave_connection[:password]}'"
              slave_clients.each do |slave|
                Chef::Log.debug("Performing query [#{slave_sql}]")
                slave.query(slave_sql)
              end
              slave_sql = 'START SLAVE'
              slave_clients.each do |slave|
                Chef::Log.debug("Performing query [#{slave_sql}]")
                slave.query(slave_sql)
              end
            ensure
              close_slave_clients
            end
          end
        end

        def client(connection)
          require 'mysql2'
          Mysql2::Client.new(
            host: connection[:host],
            socket: connection[:socket],
            username: connection[:username],
            password: connection[:password],
            port: connection[:port]
          )
        end

        def master_client
          @master_client ||= client(new_resource.connection)
        end

        def close_master_client
          @master_client.close if @master_client
        rescue Mysql2::Error
          @master_client = nil
        end

        def slave_client
          @slave_client ||= client(new_resource.slave_connection)
        end

        def close_slave_client
          @slave_client.close if @slave_client
        rescue Mysql2::Error
          @slave_client = nil
        end

        def slave_clients
          @slave_clients = new_resource.slave_clients.map { |slave| client(slave) }
        end

        def close_slave_clients
          if @slave_clients
            @slave_clients.each do |slave|
              begin
                slave.close if slave
              rescue Mysql2::Error
                Chef::Log.debug('Failed to close connection to slave.')
              end
            end
          end
        end
      end
    end
  end
end
