%w(php5-dev php5-mysql php5-xdebug libapache2-mod-php5 php5-intl php5-curl php5-gd).each do |pack|
  package pack
end

# enable display startup errors
execute "display-startup-errors" do
  not_if "cat #{node[:mrchub][:php_config_file]} | grep 'display_startup_errors = On'"
  command "sed -i 's/display_startup_errors = Off/display_startup_errors = On/g' #{node[:mrchub][:php_config_file]}"
end

# enable display errors
execute "display-errors" do
  not_if "cat #{node[:mrchub][:php_config_file]} | grep 'display_errors = On'"
  command "sed -i 's/display_errors = Off/display_errors = On/g' #{node[:mrchub][:php_config_file]}"
end

execute "phalcon ini" do
  command "echo 'extension=phalcon.so' >> #{node[:mrchub][:php_config_file]}"
end

# enable xdebug remote
execute "xdebug-remote" do
  not_if "cat #{node[:mrchub][:xdebug_config_file]} | grep 'xdebug.remote_enable=On'"
  command "echo 'xdebug.remote_enable=On' >> #{node[:mrchub][:xdebug_config_file]}"
end

# enable xdebug remote connect back
execute "xdebug-remote-connect-back" do
  not_if "cat #{node[:mrchub][:xdebug_config_file]} | grep 'xdebug.remote_connect_back=On'"
  command "echo 'xdebug.remote_connect_back=On' >> #{node[:mrchub][:xdebug_config_file]}"
end

service "apache2" do
  action :reload
end