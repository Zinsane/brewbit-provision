# Decrypt databags
ssl       = Chef::EncryptedDataBagItem.load("secrets", "ssl")

# Install SSL certificate and private key
file "/etc/ssl/certs/#{ node[:brewbit][:hostname] }.crt" do
  owner "root"
  group "root"
  mode 0644
  content ssl['cert']
end

file "/etc/ssl/private/#{ node[:brewbit][:hostname] }.key" do
  owner "root"
  group "root"
  mode 0640
  content ssl['key']
end
