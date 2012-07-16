#
# Cookbook Name:: chef-magento
# Recipe:: mysql
#
# Copyright 2012, Alistair Stead
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "mysql::server"

if node[:mysql][:master]

  gem_package "mysql" do
    action :install
    ignore_failure true
  end

  mysql_database "#{node[:magento][:db][:database]}" do
    connection ({:host => "localhost", :username => "root", :password => node['mysql']['server_root_password']})
    action :create
  end

  grants_path = value_for_platform(
    ["centos", "redhat", "suse", "fedora" ] => {
      "default" => "/etc/mage-grants.sql"
    },
    "default" => "/etc/mysql/mage-grants.sql"
  )

  template "/etc/mysql/mage-grants.sql" do
    path grants_path
    source "mage-grants.sql.erb"
    owner "root"
    group "root"
    mode "0600"
    variables(:database => node[:magento][:db])
  end

  execute "mysql-install-mage-privileges" do
      command "/usr/bin/mysql -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p' }#{node['mysql']['server_root_password']} < #{grants_path}"
      action :run
  end
end
