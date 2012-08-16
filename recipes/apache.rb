#
# Cookbook Name:: chef-magento
# Recipe:: apache
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

include_recipe "apache2"
include_recipe "chef-magento::hosts"

directory node['magento']['apache']['docroot'] do
  owner "root"
  group "root"
  mode "0755"
end

directory "#{node['magento']['apache']['docroot']}/#{node['magento']['apache']['servername']}" do
  owner "root"
  group "root"
  mode "0755"
end

directory "#{node['magento']['apache']['docroot']}/#{node['magento']['apache']['servername']}#{node['magento']['apache']['path']}" do
  owner "root"
  group "root"
  mode "0755"
end

web_app node[:magento][:apache][:servername] do
  template "apache-vhost.conf.erb"
  ssl false
  notifies :reload, resources("service[apache2]"), :delayed
end

web_app "#{node['magento']['apache']['servername']}.ssl" do
  template "apache-vhost.conf.erb"
  ssl true
  notifies :reload, resources("service[apache2]"), :delayed
end

%w{default 000-default}.each do |site|
  apache_site "#{site}" do
    enable false
    notifies :reload, resources("service[apache2]"), :delayed
  end
end