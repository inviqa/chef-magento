#
# Cookbook Name:: chef-magento
# Recipe:: sites_config
#
# Copyright 2012, Rupert Jones
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

if File.exists?("#{node['magento']['dir']}/app/etc/local.xml")

  node['magento']['sites'].each do |site|
    template "#{Chef::Config[:file_cache_path]}/sites_config.sql" do
      source "sites_config.sql.erb"
      mode 0644
      variables({
        :site => site
      })
    end
    bash "magento-sites-config" do
      code <<-EOH
/usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} #{node['magento']['db']['database']} -v < #{Chef::Config[:file_cache_path]}/site_config.sql
EOH
    end

    stores = [];
    if !site['stores'].nil?
        stores = site['stores']
    end

    # if the magento apache configuration has a run_code, then treat it
    # as a store
    if node['magento']['apache'].has_key?('run_code')
        stores << node['magento']['apache']
    end

    stores.each do |store|
      template "#{Chef::Config[:file_cache_path]}/stores_config.sql" do
        source "stores_config.sql.erb"
        mode 0644
        variables({
          :store => store
        })
      end
      bash "magento-stores-config" do
        code <<-EOH
/usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} #{node['magento']['db']['database']} -v < #{Chef::Config[:file_cache_path]}/stores_config.sql
EOH
      end
    end

  end
end
