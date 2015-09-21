require 'fileutils'

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
EON
end

bash 'create-hub-api-config' do
  user    'root'
  cwd     File.join node[:mrchub][:api_dir], 'app/config/local'
  code    <<-EON
  if [ ! -f ./application.php ]; then
    cp ./application.php.example application.php
  fi
EON
end

bash 'compile-hub-api' do
  user    'root'
  cwd     node[:mrchub][:api_dir]
  code    <<-EON
  sh ./build.sh
  EON
end

# enable php mods
execute "php-enmod" do
  command "php5enmod phalcon curl mcrypt intl xdebug"
end

# php ini settings
execute "phalcon-ini" do
  not_if "cat #{node[:mrchub][:php_ini]} | grep 'extension=phalcon.so'"
  command "echo 'extension=phalcon.so' >> #{node[:mrchub][:php_ini]}"
end

# enable display html errors
execute "display-html-errors" do
  not_if "cat #{node[:mrchub][:php_ini]} | grep 'html_errors = On'"
  command "sed -i 's/html_errors = Off/html_errors = On/g' #{node[:mrchub][:php_ini]}"
end

# create the default database if not exists
execute "create-database" do
  command "/usr/bin/mysql -uroot -p#{node[:mysql][:server_root_password]} -e 'CREATE DATABASE IF NOT EXISTS #{node[:mrchub][:db_name]}'"
end

service "apache2" do
  action :reload
end