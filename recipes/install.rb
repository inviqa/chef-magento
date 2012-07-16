#
# Cookbook Name:: chef-magento
# Recipe:: install
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

include_recipe "php"

unless File.exists?("#{node[:magento][:dir]}/app/etc/local.xml")

  install =   <<-EOH
php -f install.php -- \
--license_agreement_accepted "yes" \
--locale "#{node[:magento][:app][:locale]}" \
--timezone "#{node[:magento][:app][:timezone]}" \
--default_currency "#{node[:magento][:db][:currency]}" \
--db_host "#{node[:magento][:db][:host]}" \
--db_name "#{node[:magento][:db][:database]}" \
--db_user "#{node[:magento][:db][:username]}" \
--db_pass "#{node[:magento][:db][:password]}" \
--url "http://#{node[:magento][:apache][:servername]}/" \
--skip_url_validation \
--session_save "#{node[:magento][:app][:session_save]}" \
--admin_frontname "#{node[:magento][:app][:admin_frontname]}" \
--use_rewrites "#{node[:magento][:app][:use_rewrites]}" \
--use_secure "#{node[:magento][:app][:use_secure]}" \
--secure_base_url "https://#{node[:magento][:apache][:servername]}/" \
--use_secure_admin "#{node[:magento][:app][:user_secure_admin]}" \
--admin_firstname "#{node[:magento][:admin][:firstname]}" \
--admin_lastname "#{node[:magento][:admin][:lastname]}" \
--admin_email "#{node[:magento][:admin][:email]}" \
--admin_username "#{node[:magento][:admin][:user]}" \
--admin_password "#{node[:magento][:admin][:password]}"
EOH


  log(install) { level :info }

  bash "magento-install-site" do
    cwd "#{node[:magento][:dir]}/"
    code <<-EOH
cd #{node[:magento][:dir]}/ && \
#{install}
EOH
  end

  indexsite = <<-EOH
php -f shell/indexer.php -- reindexall
EOH

  bash "magento-index-site" do
    cwd "#{node[:magento][:dir]}/"
    code <<-EOH
cd #{node[:magento][:dir]}/ && \
#{indexsite}
EOH
  end
end