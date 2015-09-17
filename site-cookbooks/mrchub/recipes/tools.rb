#
# Install xDebug php package
#
php_pear "xdebug" do
  action :install
  zend_extensions ['xdebug.so']
  directives(
      :remote_enable => "on",
      :remote_connect_back => "on",
      :idekey => "vagrant"
  )
end

%w{apache2 cgi cli}.each do |mod|
  link "/etc/php5/#{mod}/conf.d/xdebug.ini" do
    to "#{node['php']['ext_conf_dir']}/xdebug.ini"
  end
end