#
# Cookbook Name:: chef-magento
# Recipe:: solr
#
# Copyright 2012, Inviqa
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

include_recipe "solr"

directory node['solr']['config'] do
    action      :delete
    recursive   true
end

remote_directory node['solr']['config'] do
  source       "solr.config"
  owner        node['jetty']['user']
  group        node['jetty']['group']
  files_owner  node['jetty']['user']
  files_group  node['jetty']['group']
  files_backup 0
  files_mode   "644"
  purge        true
  notifies     :restart, resources(:service => "jetty"), :immediately
end
