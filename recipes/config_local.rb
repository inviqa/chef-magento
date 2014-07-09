#
# Cookbook Name:: chef-magento
# Recipe:: config_local
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

if node['magento']['capistrano']['enabled'] == true
  config_path = "#{node['magento']['apache']['docroot']}/#{node['magento']['apache']['servername']}/shared/#{node['magento']['app']['base_path']}"
else
  config_path = node['magento']['dir']
end

directory config_path do
  recursive true
  mode "0755"
  action :create
end

template "#{config_path}/app/etc/local.xml" do
  source "local.xml.erb"
  mode 0644
  variables({
    :magento => node['magento']
  })
end
