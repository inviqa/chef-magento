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

if Chef::Config[:solo]
  missing_attrs = %w(
    crypt_key
  ).select { |attr| node['magento']['app'][attr].nil? }.map { |attr| "node['magento']['app']['#{attr}']" }

  unless missing_attrs.empty?
    fail "You must set #{missing_attrs.join(', ')} in chef-solo mode."
  end
else
  # generate all passwords
  node.set_unless['magento']['app']['crypt_key'] = secure_password
  node.save
end

template "#{node['magento']['dir']}/app/etc/local.xml" do
  source "local.xml.erb"
  mode 0644
end