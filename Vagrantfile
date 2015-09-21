# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'chef'
require 'json'

Chef::Config.from_file(File.join(File.dirname(__FILE__), '.chef', 'knife.rb'))
vagrant_json = JSON.parse(Pathname(__FILE__).dirname.join('nodes', (ENV['NODE'] || 'vagrant.json')).read)

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
HOSTNAME = 'my.mrchub.local'

IP_ADDRESS = '192.168.33.10'
SYNC_TYPE = 'rsync' # Synchronization type may be 'nfs' or 'rsync'

Vagrant.require_version '>= 1.5'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = 'ubuntu/trusty64'
  config.vm.box_url = 'https://vagrantcloud.com/ubuntu/trusty64'
  config.ssh.forward_agent = true

  config.vm.hostname = HOSTNAME
  config.vm.network :forwarded_port, guest: 80, host: 8085
  config.vm.network :forwarded_port, guest: 8080, host: 8086

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = Chef::Config[:cookbook_path]
    chef.roles_path = Chef::Config[:role_path]
    chef.data_bags_path = Chef::Config[:data_bag_path]

    chef.environments_path = Chef::Config[:environment_path]
    chef.environment = ENV['ENVIRONMENT'] || 'development'

    chef.run_list = vagrant_json.delete('run_list')
    chef.json = vagrant_json
  end

  config.vm.network "private_network", ip: IP_ADDRESS

  ## Shared folders
  if Vagrant::Util::Platform.windows?
    sync_options = {
        :mount_options => ["dmode=776", "fmode=775"],
        :owner => 'vagrant',
        :group => 'vagrant'
    }
  else
    if SYNC_TYPE == 'rsync'
      sync_options = {
          :type => 'rsync',
          :mount_options => ["dmode=775", "fmode=775"],
          :owner => 'vagrant',
          :group => 'vagrant',
          :rsync__args => ['--verbose', '--archive', '-z'],
          :rsync__exclude => ['.git/', '.vagrant/'],
          :rsync__auto => true
      }
    else
      sync_options = {
          :nfs => { :mount_options => ["dmode=776", "fmode=775"] }
      }
    end
  end

  config.vm.synced_folder ".", "/vagrant", sync_options

  # Optional (Remove if desired)
  config.vm.provider :virtualbox do |vb|
    host = RbConfig::CONFIG['host_os']

    # Give VM 1/4 system memory & access to all cpu cores on the host
    if host =~ /darwin/
      cpus = `sysctl -n hw.ncpu`.to_i
      # sysctl returns Bytes and we need to convert to MB
      memory = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
    elsif host =~ /linux/
      cpus = `nproc`.to_i
      # meminfo shows KB and we need to convert to MB
      memory = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
    else # sorry Windows folks, I can't help you
      cpus = 1
      memory = 1024
    end

    vb.customize [ "modifyvm", :id, "--cpus", cpus ]
    vb.customize [ 'modifyvm', :id, '--memory', memory ]
    vb.customize [ 'modifyvm', :id, '--natdnshostresolver1', 'on']
    vb.customize [ 'modifyvm', :id, '--natdnsproxy1', 'on' ]
  end

end
