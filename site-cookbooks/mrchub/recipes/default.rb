#
# Cookbook Name:: mrchub
# Recipe:: default
#

%w(git git-core curl gcc autoconf zip unzip gcc perl make jq mc vim).each do |pack|
  package pack
end

include_recipe 'apache2'
include_recipe 'apache2::mod_rewrite'
include_recipe 'apache2::mod_alias'
include_recipe 'apache2::mod_php5'

include_recipe 'php'
include_recipe 'composer'

# include_recipe 'mrchub::tools'
include_recipe 'mrchub::install'
include_recipe 'mrchub::vhosts'