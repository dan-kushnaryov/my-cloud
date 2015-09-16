#
# Cookbook Name:: mrchub
# Recipe:: default
#

%w(git ntp).each do |pack|
  package pack
end

%w(apache2 apache2::mpm_prefork apache2::mod_php5 apache2::mod_ssl).each do |recipe|
  include_recipe recipe
end