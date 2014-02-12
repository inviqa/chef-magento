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

include_recipe "mysql::client"
include_recipe "mysql::server"

if node['mysql']['master']

  mysql_connection_info = {
    :host => "localhost",
    :username => "root",
    :password => node['mysql']['server_root_password']
  }

  mysql_database node['magento']['db']['database'] do
    connection (mysql_connection_info)
    action :create
  end

  mysql_database_user node['magento']['db']['username'] do
    connection mysql_connection_info
    password node['magento']['db']['password']
    database_name node['magento']['db']['database']
    host 'localhost'
    privileges [:all]
    action :grant
  end
end
