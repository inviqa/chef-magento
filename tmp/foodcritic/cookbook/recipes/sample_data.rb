#
# Cookbook Name:: chef-magento
# Recipe:: sample_data
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


include_recipe "chef-magento::mysql"
require 'mysql'

def database_exists?
  begin
    con = Mysql.new('localhost', 'root', node['mysql']['server_root_password'])
    rs = con.query("SELECT 1 FROM Information_schema.tables WHERE table_name = 'admin_user' AND table_schema = '#{node['magento']['db']['database']}'")
    is_installed = rs.num_rows
    con.close
  rescue Exception => e
    is_installed = 0
  end
  is_installed == 1
end

def has_administrator?
  begin
    con = Mysql.new('localhost', 'root', node['mysql']['server_root_password'], node['magento']['db']['database'])
    rs = con.query("SELECT COUNT(user_id) AS num_users FROM admin_user")
    administrators = rs.num_rows
    con.close
  rescue Exception => e
    administrators = 0
  end
  administrators >= 1
end

def is_installed?
  database_exists? == true && has_administrator? == true
end

if !is_installed?

  log(database_exists?.to_s) {level :info }
  log(has_administrator?.to_s) {level :info }
  log(is_installed?.to_s) {level :info }

  directory node['magento']['dir'] do
    owner "root"
    group "root"
    mode "0755"
  end

  directory "#{node['magento']['dir']}/media/" do
    owner "root"
    group "root"
    mode "0755"
  end

  remote_file "#{Chef::Config[:file_cache_path]}/magento-sample-data.tar.gz" do
    source node['magento']['sample_data']['url']
    mode "0644"
    action :create_if_missing
  end

  bash "magento-sample-data" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
    mkdir #{name}
    cd #{name}
    tar -zxvf  #{Chef::Config[:file_cache_path]}/magento-sample-data.tar.gz
    mv magento-sample-data-* data
    mv data/media/* #{node['magento']['dir']}/media/
    chmod -R o+w  #{node['magento']['dir']}/media
    mv data/magento_sample_data*.sql data.sql 2>/dev/null
    /usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} #{node['magento']['db']['database']} -v < data.sql
    EOH
  end
end

