default[:mrchub][:php_config_file] = "/etc/php5/apache2/php.ini"
default[:mrchub][:xdebug_config_file] = "/etc/php5/conf.d/xdebug.ini"

default[:mrchub][:src_path] = "/usr/local/share"
default[:mrchub][:docroot_dir] = "/vagrant/mrc-hub"

default[:mrchub][:api_host] = "api.mrchub.local"
default[:mrchub][:api_dir] = "#{default[:mrchub][:docroot_dir]}/Hub-API/"