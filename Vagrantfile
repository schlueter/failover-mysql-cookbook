# -*- mode: ruby -*-
# vi: set ft=ruby :

##
#    This Vagrantfile provisions a web server hosting wordpress served
#    using Nginx and a master slave configuration of percona sql servers.
#
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

require 'yaml'

Vagrant.configure(2) do |config|
  CONFIGURATION = YAML.load_file(File.join(File.dirname(__FILE__), 'vagrant_configuration.yml'))

  config.omnibus.chef_version = '12.1.1' if Vagrant.has_plugin?('vagrant-omnibus')
  config.cache.scope = :box if Vagrant.has_plugin?('vagrant-cachier')

  config.vm.box = CONFIGURATION['BOX']

  @config = config

  def sql1(chef_json='sql1')
    @config.vm.define 'sql1' do |sql|
      sql.vm.hostname = 'sql1'
      sql.vm.network :private_network, ip: CONFIGURATION['IP_ADDRESSES']['sql1']

      sql.vm.provider :virtualbox do |vbox|
        vbox.memory = CONFIGURATION['VMS']['sql1']['memory']
        vbox.cpus = CONFIGURATION['VMS']['sql1']['cpus']
      end

      sql.vm.provision :chef_solo do |chef|
        chef.run_list = %w(failover-mysql)
        chef.json = CONFIGURATION['CHEF_JSON'][chef_json]
      end
    end
  end

  def sql2(chef_json='sql2')
    @config.vm.define 'sql2' do |sql|
      sql.vm.hostname = 'sql2'
      sql.vm.network :private_network, ip: CONFIGURATION['IP_ADDRESSES']['sql2']

      sql.vm.provider :virtualbox do |vbox|
        vbox.memory = CONFIGURATION['VMS']['sql2']['memory']
        vbox.cpus = CONFIGURATION['VMS']['sql2']['cpus']
      end

      sql.vm.provision :chef_solo do |chef|
        chef.run_list = %w(failover-mysql)
        chef.json = CONFIGURATION['CHEF_JSON'][chef_json]
      end
    end
  end

  def web(chef_json='web')
    @config.vm.define 'web' do |web|
      web.vm.hostname = 'web'
      web.vm.network :private_network, ip: CONFIGURATION['IP_ADDRESSES']['web']

      web.vm.network 'forwarded_port', guest: 80, host: CONFIGURATION['HTTP_PORT']

      web.vm.provider :virtualbox do |vbox|
        vbox.memory = CONFIGURATION['VMS']['web']['memory']
        vbox.cpus = CONFIGURATION['VMS']['web']['cpus']
      end

      web.vm.provision :chef_solo do |chef|
        chef.run_list = %w(failover-mysql::wordpress)
        chef.json = CONFIGURATION['CHEF_JSON'][chef_json]
      end
    end
  end

  if ENV['FAILOVER']
    begin
      # Read current master from .failover file
      ::File.open('.failover', 'r').each do |line|
        @master = line.split('=')[1] if line.start_with? 'master='
      end
    rescue Errno::ENOENT
      puts 'No .failover file found. Assuming sql1 is current master'
      @master = 'sql1'
    end

    if @master == 'sql1'
      sql2('sql2_failover')
    else
      sql1('sql1_failover')
    end
    # Clear the contents of the file
    File.open('.failover', 'w') {}
    # Populate the file with the current master
    File.open('.failover', 'w') do |file|
      file.write CONFIGURATION['FAILOVER_FILE_PREFIX']
      file.write "master=#{@master == 'sql1' ? 'sql2' : 'sql1'}"
    end
    web('web_failover')
  else
    sql1
    sql2
    web
  end
end
