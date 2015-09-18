# bash 'compile-phalcon' do
#   user    'root'
#   cwd     '/vagrant'
#   code    <<-EON
# apt-add-repository -y ppa:phalcon/stable
# apt-get update
# apt-get install -y php5-phalcon
# cat > composer.json <<EOF
# {
#   "require": {
#       "phalcon/devtools": "dev-master"
#   }
# }
# EOF
# composer install
# rm composer.json
# rm composer.lock
# mkdir /opt/phalcon-tools
# mv /vagrant/vendor/phalcon/devtools/* /opt/phalcon-tools
# ln -s /opt/phalcon-tools/phalcon.php /usr/bin/phalcon
# chmod ugo+x /usr/bin/phalcon
# rm -rf /vagrant/vendor
# # php5enmod phalcon curl mcrypt intl
# EON
# end

execute "phalcon-ini" do
  not_if "cat #{node[:mrchub][:php_ini]} | grep 'extension=phalcon.so'"
  command "echo 'extension=phalcon.so' >> #{node[:mrchub][:php_ini]}"
end

# enable display html errors
execute "display-html-errors" do
  not_if "cat #{node[:mrchub][:php_ini]} | grep 'html_errors = On'"
  command "sed -i 's/html_errors = Off/html_errors = On/g' #{node[:mrchub][:php_ini]}"
end

# mysql_service "hub-api" do
#   port '3306'
#   version '5.5'
#   bind_address '0.0.0.0'
#   initial_root_password 'root'
#   action [:create, :start]
# end

# Create database if it does not exist
# execute "create-database" do
#   command "/usr/bin/mysqladmin -u root -p1 create hub_api -h 127.0.0.1"
# end

service "apache2" do
  action :reload
end