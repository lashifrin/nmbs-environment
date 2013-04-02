#
# Cookbook Name:: nimbus_directory
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
tarball = "install-nimbus.tar.gz"

java_home = node['java']['java_home']

directory "/opt/app" do
    mode "0775"
    owner "nimbus"
    group "nimbus"
    action :create
end

directory "/opt/app/bsca" do
    mode "0777"
    owner "nimbus"
    group "nimbus"
    action :create
end

remote_file "/tmp/#{tarball}" do
 source "http://172.16.31.21:8081/artifactory/libs-release/x86/install/nimbus/#{tarball}"
 mode "0777"
end

execute "tar" do
 user "nimbus"
 group "nimbus"
 installation_dir = "/opt/app/bsca"
 cwd installation_dir
 command "tar zxf /tmp/#{tarball}"
 creates installation_dir + "/nimbus"
 action :run
end

# get files
bash "delete_links" do
  user "nimbus"
  group "nimbus"
  code <<-EOH
  cd /opt/app/bsca/nimbus
  rm -f jdk
  rm -f tomcat
  ln -s /usr/share/tomcat tomcat
  ln -s /usr/lib/jvm/java-6-openjdk jdk
  rm /opt/app/bsca/nimbus/bin/nimbus.sh
  chmod 777 /opt/app/bsca/nimbus/tomcat/conf/*
  EOH
end

#bash "riak_links" do
#  user "nimbus"
#  group "nimbus"
#  code <<-EOH
#  cd /opt/app/bsca/nimbus
#  mkdir -p riak/bin
#  ln -s /etc/riak riak/etc
#  chmod -R 777 /opt/app/bsca/nimbus/riak/etc
#  chown -R "nimbus:nimbus" /opt/app/bsca/nimbus/riak/etc
#  cd /opt/app/bsca/nimbus/riak/etc
#  mv app.config app.config.org
#  mv vm.args vm.args.org
#  EOH
#end

remote_file "/opt/app/bsca/nimbus/tomcat/webapps/nimbus.war" do
 source "http://172.16.31.21:8081/artifactory/libs-release-local/nimbus/nimbus/2.4.2/nimbus-2.4.2.war"
 owner "nimbus"
 group "nimbus"
 mode "0777"
end

#directory "/opt/app/bsca/nimbus/tomcat/logs" do
#  recursive true
#  action :delete
#end

#directory "/opt/app/bsca/nimbus/tomcat/logs" do
#    mode "0777"
#    owner "nimbus"
#    group "nimbus"
#    action :create
#end

template "/opt/app/bsca/nimbus/conf/hazelcast.xml" do
 source "hazelcast.xml.erb"
 owner "nimbus"
 group "nimbus"
 mode "0777"
end

#template "/opt/app/bsca/nimbus/riak/etc/app.config" do
# source "app.config.erb"
# owner "nimbus"
# group "nimbus"
# mode "0777"
#end

#template "/opt/app/bsca/nimbus/riak/etc/vm.args" do
# source "vm.args.erb"
# owner "nimbus"
# group "nimbus"
# mode "0777"
#end

#template "/opt/app/bsca/nimbus/riak/etc/key.pem" do
# source "key.pem.erb"
# owner "nimbus"
# group "nimbus"
# mode "0777"
#end

#template "/opt/app/bsca/nimbus/riak/etc/cert.pem" do
# source "cert.pem.erb"
# owner "nimbus"
# group "nimbus"
# mode "0777"
#end

template "/opt/app/bsca/nimbus/bin/nimbus.sh" do
 source "nimbus.sh.erb"
 owner "nimbus"
 group "nimbus"
 mode "0777"
end

script "start_nimbus" do
  interpreter "bash"
  user "nimbus"
  group "nimbus"
  cwd "/opt/app/bsca/nimbus/bin"
  code <<-EOH
  ./nimbus.sh start
  EOH
end

