# Decrypt databags
tumblr    = Chef::EncryptedDataBagItem.load("secrets", "tumblr")
mailchimp = Chef::EncryptedDataBagItem.load("secrets", "mailchimp")
aws       = Chef::EncryptedDataBagItem.load("secrets", "aws")
hipchat   = Chef::EncryptedDataBagItem.load("secrets", "hipchat")
email     = Chef::EncryptedDataBagItem.load("secrets", "email")
ssl       = Chef::EncryptedDataBagItem.load("secrets", "ssl")

# Create the deploy user/group
users_manage "rvm" do
  action :create
end

sudo 'deploy' do
  user      'deploy'
  commands  ['ls']
  nopasswd  true
end

# Create the application deployment directory
[ "/var/www/#{ node[:brewbit][:hostname] }",
  "/var/www/dg.#{ node[:brewbit][:hostname] }"
].each do |path|
  directory path do
    owner "deploy"
    group "deploy"
    mode 02700
    recursive true
  end
end

[ "/var/www/#{ node[:brewbit][:hostname] }/releases",
  "/var/www/#{ node[:brewbit][:hostname] }/shared",
  "/var/www/#{ node[:brewbit][:hostname] }/shared/tmp",
  "/var/www/#{ node[:brewbit][:hostname] }/shared/tmp/pids",
  "/var/www/#{ node[:brewbit][:hostname] }/shared/tmp/sockets",
  "/var/www/#{ node[:brewbit][:hostname] }/shared/log",
  "/var/www/dg.#{ node[:brewbit][:hostname] }/releases",
  "/var/www/dg.#{ node[:brewbit][:hostname] }/shared",
  "/var/www/dg.#{ node[:brewbit][:hostname] }/shared/tmp",
  "/var/www/dg.#{ node[:brewbit][:hostname] }/shared/tmp/pids",
  "/var/www/dg.#{ node[:brewbit][:hostname] }/shared/tmp/sockets",
  "/var/www/dg.#{ node[:brewbit][:hostname] }/shared/log"
].each do |path|
  directory path do
    owner "deploy"
    group "deploy"
    mode 02775
  end
end

[ "/var/log/#{ node[:brewbit][:hostname] }",
  "/var/log/dg.#{ node[:brewbit][:hostname] }"
].each do |path|
  directory path do
    owner "deploy"
    group "deploy"
    mode 02775
    recursive true
  end
end

# Create the dotenv file containing secrets
template "/var/www/#{ node[:brewbit][:hostname] }/shared/.env" do
  source "var/www/app/shared/dotenv.erb"
  mode 0640
  owner "deploy"
  group "deploy"
  variables({
     :tumblr    => tumblr,
     :mailchimp => mailchimp,
     :hipchat   => hipchat,
     :email     => email,
     :aws       => aws
  })
end

# Install SSL certificate and private key
file "/etc/ssl/certs/#{ node[:brewbit][:hostname] }.crt" do
  owner "root"
  group "root"
  mode 0644
  content ssl['cert']
end

file "/etc/ssl/private/#{ node[:brewbit][:hostname] }.key" do
  owner "root"
  group "ssl-cert"
  mode 0640
  content ssl['key']
end
