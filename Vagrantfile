# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.omnibus.chef_version = '11.10.0'
  
  config.vm.define :staging, primary: true do |staging|
    staging.vm.hostname = 'staging.brewbit.com'
  end

  config.vm.define :production do |production|
    production.vm.hostname = 'brewbit.com'
  end

  config.vm.define :prod do |prod|
    prod.vm.hostname = 'brewbit.com'
  end

  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.username = 'vagrant'
    override.ssh.private_key_path = '~/.ssh/id_rsa'
    provider.ssh_key_name = 'nick'
    
    override.vm.box = 'digital_ocean'
    override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
    
    provider.client_id = ENV['DIGITAL_OCEAN_CLIENT_ID']
    provider.api_key = ENV['DIGITAL_OCEAN_API_KEY']
    provider.image = 'Ubuntu 13.10 x64'
    provider.region = 'San Francisco 1'
    provider.size = '2GB'
    provider.private_networking = false
    provider.backups_enabled = false
    provider.setup = true
  end

  config.vm.provision :chef_solo do |chef|
    chef.roles_path = 'roles'
    chef.environments_path = 'environments'
    chef.cookbooks_path = ['cookbooks', 'site-cookbooks']
    chef.data_bags_path = 'data_bags'
    chef.encrypted_data_bag_secret_key_path = "#{ENV['HOME']}/.chef/encrypted_data_bag_secret"

    chef.environment = 'production' # TODO make this dynamic!
    chef.add_role 'web'
  end
end

