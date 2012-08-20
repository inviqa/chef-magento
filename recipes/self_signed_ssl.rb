#
# Cookbook Name:: chef-magento
# Recipe:: self_signed_ssl
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

bash "Create SSL Certificates" do
  cwd "#{node['apache']['dir']}/ssl"
  code <<-EOH
  umask 022
  openssl genrsa 2048 > #{node['magento']['apache']['servername']}.key
  openssl req -batch -new -x509 -days 365 -key #{node['magento']['apache']['servername']}.key -out #{node['magento']['apache']['servername']}.crt
  cat #{node['magento']['apache']['servername']}.crt #{node['magento']['apache']['servername']}.key > #{node['magento']['apache']['servername']}.pem
  EOH
  only_if { File.zero?("#{node['apache']['dir']}/ssl/#{node['magento']['apache']['servername']}.pem") }
  action :nothing
end

cookbook_file "#{node['apache']['dir']}/ssl/#{node['magento']['apache']['servername']}.pem" do
  source "cert.pem"
  mode 0644
  owner "root"
  group "root"
  notifies :run, resources(:bash => "Create SSL Certificates"), :immediately
end