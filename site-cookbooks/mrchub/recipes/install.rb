%w(php5 php5-dev php5-xdebug apache2 libapache2-mod-php5 libpcre3-dev php5-mcrypt php5-curl php5-intl php5-mysql libpcre3-dev gcc make autoconf).each do |pack|
  package pack
end

bash 'compile-phalcon' do
  user    'root'
  cwd     '/vagrant'
  code    <<-EON
apt-add-repository -y ppa:phalcon/stable
apt-get update
apt-get install -y php5-phalcon
cat > composer.json <<EOF
{
  "require": {
      "phalcon/devtools": "dev-master"
  }
}
EOF
composer install
rm composer.json
rm composer.lock
mkdir /opt/phalcon-tools
mv /vagrant/vendor/phalcon/devtools/* /opt/phalcon-tools
ln -s /opt/phalcon-tools/phalcon.php /usr/bin/phalcon
chmod ugo+x /usr/bin/phalcon
rm -rf /vagrant/vendor
php5enmod phalcon curl mcrypt intl
EON
end

execute "phalcon-ini" do
  not_if "cat #{node[:mrchub][:php_config_file]} | grep 'extension=phalcon.so'"
  command "echo 'extension=phalcon.so' >> #{node[:mrchub][:php_config_file]}"
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

# set xdebug idekey
execute "xdebug-idekey" do
  not_if "cat #{node[:mrchub][:xdebug_config_file]} | grep 'xdebug.idekey=vagrant'"
  command "echo 'xdebug.idekey=vagrant' >> #{node[:mrchub][:xdebug_config_file]}"
end

service "apache2" do
  action :reload
end