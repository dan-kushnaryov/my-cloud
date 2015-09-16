%w(php5-dev libpcre3-dev gcc make).each do |pack|
  package pack
end

bash 'compile-phalcon' do
  user    'root'
  cwd     '/tmp/cphalcon/build'
  code    "sudo ./install"
  action  :nothing
end

git '/tmp/cphalcon' do
  repository  'https://github.com/phalcon/cphalcon.git'
  revision    'master'
  action      :sync
  notifies    :run, 'bash[compile-phalcon]'
end

service "apache2" do
  action :reload
end