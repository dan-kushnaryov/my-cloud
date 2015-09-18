#
# Cookbook Name:: mrchub
# Recipe:: default
#

%w(git git-core curl gcc autoconf zip unzip perl make jq mc vim libpcre3-dev gcc make).each do |pack|
  package pack
end

# Set mysql debian and replication passwords to the root one
node.default['mysql']['server_debian_password'] = node['mysql']['server_root_password'];
node.default['mysql']['server_repl_password'] = node['mysql']['server_root_password'];

include_recipe 'apache2'
include_recipe 'apache2::mod_rewrite'
include_recipe 'apache2::mod_alias'
include_recipe 'apache2::mod_php5'
include_recipe 'mysql::server'
include_recipe 'mysql::ruby'
include_recipe 'php'
include_recipe 'php::module_apc'
include_recipe 'php::module_curl'
include_recipe 'php::module_gd'
include_recipe 'php::module_mcrypt'
include_recipe 'php::module_mysql'
include_recipe 'php::module_curl'
include_recipe 'php::module_intl'
include_recipe 'php::apache2'
include_recipe 'composer'
include_recipe 'xdebug'

# include_recipe 'mrchub::tools'
include_recipe 'mrchub::install'
include_recipe 'mrchub::vhosts'