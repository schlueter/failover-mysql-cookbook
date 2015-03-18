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

include_recipe "wordpress::#{node['failover_wordpress']['web']['server']}"

db = node['failover_wordpress']['database']

# Override the wordpress ckbk's config because of a chef bug which makes controlling
# the value of the wordpress' user's password in attributes difficult.
# https://tickets.opscode.com/browse/CHEF-2945#comment-50680

template "#{node['wordpress']['dir']}/wp-config.php" do
  source 'wp-config.php.erb'
  mode node['wordpress']['config_perms']
  variables(
    db_name: db['name'],
    db_user: db['app_user'],
    db_password: db['app_pass'],
    db_host: db['host'],
    db_prefix: node['wordpress']['db']['prefix'],
    db_charset: node['wordpress']['db']['charset'],
    db_collate: node['wordpress']['db']['collate'],
    auth_key: node['wordpress']['keys']['auth'],
    secure_auth_key: node['wordpress']['keys']['secure_auth'],
    logged_in_key: node['wordpress']['keys']['logged_in'],
    nonce_key: node['wordpress']['keys']['nonce'],
    auth_salt: node['wordpress']['salt']['auth'],
    secure_auth_salt: node['wordpress']['salt']['secure_auth'],
    logged_in_salt: node['wordpress']['salt']['logged_in'],
    nonce_salt: node['wordpress']['salt']['nonce'],
    lang: node['wordpress']['languages']['lang'],
    allow_multisite: node['wordpress']['allow_multisite'],
    wp_config_options: node['wordpress']['wp_config_options']
  )
  owner node['wordpress']['install']['user']
  group node['wordpress']['install']['group']
  action :create
  cookbook 'wordpress'
end
