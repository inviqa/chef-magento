#
# Cookbook Name:: chef-magento
# Recipe:: download
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


unless File.exists?("#{node[:magento][:dir]}/index.php")

  remote_file "#{Chef::Config[:file_cache_path]}/magento.tar.gz" do
    source node[:magento][:downloader][:url]
    mode "0644"
  end

  directory "#{node[:magento][:dir]}" do
    owner "root"
    group "www-data"
    mode "0755"
    action :create
    recursive true
  end

  execute "untar-magento" do
    cwd node[:magento][:dir]
    command "tar -zxvf #{Chef::Config[:file_cache_path]}/magento.tar.gz"
  end

  execute "set-perms" do
    command "chmod o+w var var/.htaccess app/etc"
    command "chmod -R o+w media"
  end
end