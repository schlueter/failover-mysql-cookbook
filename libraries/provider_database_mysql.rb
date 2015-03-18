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
          log_file = nil
          log_pos = nil

          converge_by "Querying master '#{new_resource.database_name}' for log properties" do
            begin
              master_sql = 'SHOW MASTER STATUS'
              Chef::Log.debug("Performing query [#{master_sql}]")
              master_result = master_client.query(master_sql)
              master_result.each do |result|
                Chef::Log.info("Retrieved log file name #{result['File']} from master")
                log_file = result['File']
                Chef::Log.info("Retrieved log file position #{result['Position']} from master")
                log_pos = result['Position']
              end
            ensure
              close_master_client
            end
          end

          converge_by "Setting master on slave '#{new_resource.database_name}'" do
            begin
              slave_sql = <<-SQL
CHANGE MASTER TO
  MASTER_HOST='#{new_resource.connection[:host]}',
  MASTER_USER='#{new_resource.connection[:username]}',
  MASTER_PASSWORD='#{new_resource.connection[:password]}',
  MASTER_LOG_FILE='#{log_file}',
  MASTER_LOG_POS=#{log_pos}
              SQL
              # Chef::Log.log("Performing query [#{slave_sql}]")
              slave_client.query(slave_sql)
            ensure
              close_slave_client
            end
          end
        end

        def master_client
          require 'mysql2'
          @master_client ||=
            Mysql2::Client.new(
            host: new_resource.connection[:host],
            socket: new_resource.connection[:socket],
            username: new_resource.connection[:username],
            password: new_resource.connection[:password],
            port: new_resource.connection[:port]
            )
        end

        def close_master_client
          @master_client.close if @master_client
        rescue Mysql2::Error
          @master_client = nil
        end

        def slave_client
          require 'mysql2'
          @slave_client ||=
            Mysql2::Client.new(
            host: new_resource.slave_connection[:host],
            socket: new_resource.slave_connection[:socket],
            username: new_resource.slave_connection[:username],
            password: new_resource.slave_connection[:password],
            port: new_resource.slave_connection[:port]
            )
        end

        def close_slave_client
          @slave_client.close if @slave_client
        rescue Mysql2::Error
          @slave_client = nil
        end
      end
    end
  end
end
