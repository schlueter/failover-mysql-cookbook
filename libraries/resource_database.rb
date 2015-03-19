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

require 'chef/resource'

class Chef
  class Resource
    # Augment Resource::Database defined in database ckbk
    class Database < Chef::Resource
      def initialize(name, run_context=nil)
        super
        @resource_name = :database
        @database_name = name
        @allowed_actions.push(:create, :drop, :query, :slave, :promote)
        @action = :create
      end

      def slave_connection(arg=nil)
        set_or_return(
          :slave_connection,
          arg,
          required: false
        )
      end

      def slave_clients(arg=nil)
        set_or_return(
          :slave_clients,
          arg,
          required: false
        )
      end
    end
  end
end
