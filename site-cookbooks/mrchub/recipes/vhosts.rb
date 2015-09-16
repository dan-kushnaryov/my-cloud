#
# Configure Apache virtual hosts
#

apache_site "000-default" do
  enable false
end

web_app node[:mrchub][:api_host] do
  template "api.site.erb"
  api_dir node[:mrchub][:api_dir]
  docroot_dir node[:mrchub][:docroot_dir]
  server_name node[:mrchub][:api_host]
end