#
# Configure Apache virtual hosts
#

apache_site "000-default" do
  enable false
end

web_app node[:mrchub][:api_host] do
  template "api.site.erb"
  mode 0755
  owner 'vagrant'
  group 'vagrant'
  api_dir node[:mrchub][:api_dir]
  docroot_dir node[:mrchub][:docroot_dir]
  server_name node[:mrchub][:api_host]
end

service "apache2" do
  action :reload
end