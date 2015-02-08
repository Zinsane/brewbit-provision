brewbit-provision
=================

This project contains provisioning scripts that can be used to spin up a new VM capable of running brewbit.com. Provisioning starts with Vagrant which creates a VM and configures basic SSH access. Vagrant then hands the VM off to chef which fully configures the VM by installing all necessary dependencies, the database, SSL certs, environment variables, etc. In order to perform provisioning, you must have the DigitalOcean credentials stored in the following environment variables on your local machine:

DIGITAL_OCEAN_CLIENT_ID=<snip>
DIGITAL_OCEAN_API_KEY=<snip>

You must also have a copy of the Chef encrypted data bag secret key which is necessary for decrypting the data bags that contain secrets such as API keys and passwords that the server requires. This file should be stored at:

~/.chef/encrypted_data_bag_secret

In order to install vagrant, chef and all other dependencies:

bundle install

After your environment is configured, provisioning is started with:

vagrant up

Managing secrets stored in encrypted data bags:

First set the EDITOR environment variable to the text editor that you will use to edit data bags.

Create a new data bag (for instance mailchimp):

knife solo data bag create secrets mailchimp --secret-file ~/.chef/encrypted_data_bag_secret

This will open the data bag in your chosen text editor. Edit the contents, then save and close it. Knife will encrypt and write the data bag to disk.

Edit an existing data bag (for instance ssl):

knife solo data bag edit secrets ssl --secret-file ~/.chef/encrypted_data_bag_secret

This will decrypt and open the data bag in your chosen text editor. Edit the contents, then save and close it. Knife will reencrypt and write the data bag to disk.

Edit early.rb and dotenv.erb to add these secrets to the server's environment.
