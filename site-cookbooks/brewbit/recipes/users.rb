
user "deploy" do
  home '/home/deploy'
  shell '/bin/bash'
  supports manage_home: true # create the home dir
  action [:create, :lock]
end

sudo 'deploy' do
  user      'deploy'
  commands  [
    "/sbin/start *brewbit.com",
    "/sbin/stop *brewbit.com",
    "/sbin/restart *brewbit.com",
    "/bin/rm -f /etc/init/*brewbit.com*",
    "/usr/bin/env",
    "/bin/sed"
  ]
  nopasswd  true
end
