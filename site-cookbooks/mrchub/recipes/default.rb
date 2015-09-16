#
# Cookbook Name:: mrchub
# Recipe:: default
#

%w(git git-core gcc autoconf zip unzip gcc perl make jq).each do |pack|
  package pack
end

include_recipe 'apache2'
include_recipe 'apache2::mod_rewrite'
include_recipe 'apache2::mod_alias'
include_recipe 'apache2::mod_php5'
include_recipe 'php'

include_recipe 'mrchub::php-install'
include_recipe 'mrchub::phalcon-install'
include_recipe 'mrchub::vhosts'