default[:mrchub][:php_ini] = "#{node['php']['apache_conf_dir']}/php.ini"
default[:mrchub][:xdebug_config_file] = "/etc/php5/mods-available/xdebug.ini"

default[:mrchub][:src_path] = "/usr/local/share"
default[:mrchub][:docroot_dir] = "/vagrant/mrc-hub"

default[:mrchub][:api_host] = "api.mrchub.local"
default[:mrchub][:api_dir] = "#{default[:mrchub][:docroot_dir]}/Hub-API/"

default[:mrchub][:db_name] = "hub_api"
default[:mrchub][:db_pass] = "1"

