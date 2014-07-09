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

require 'mysql'
require 'uri'

def database_exists?
  begin
    con = Mysql.new(node['magento']['db']['host'], node['magento']['db']['username'], node['magento']['db']['password'])
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
    con = Mysql.new(node['magento']['db']['host'], node['magento']['db']['username'], node['magento']['db']['password'], node['magento']['db']['database'])
    rs = con.query("SELECT COUNT(user_id) AS num_users FROM admin_user")
    administrators = rs.num_rows
    con.close
  rescue Exception => e
    administrators = 0
  end
  administrators >= 1
end

def not_installed?
  database_exists? == false && has_administrator? == false
end

if File.exists?("#{node['magento']['dir']}/install.php")
  if not_installed?
    url = URI::HTTP.build({:host=>node['magento']['apache']['servername'],:port=>Integer(node['magento']['apache']['unsecure_port']),:path=>'/'})
    secure_url = URI::HTTPS.build({:host=>node['magento']['apache']['servername'],:port=>Integer(node['magento']['apache']['secure_port']),:path=>'/'})
    install =   <<-EOH
    php -f install.php -- \
    --license_agreement_accepted "yes" \
    --locale "#{node['magento']['app']['locale']}" \
    --timezone "#{node['magento']['app']['timezone']}" \
    --default_currency "#{node['magento']['db']['currency']}" \
    --db_host "#{node['magento']['db']['host']}" \
    --db_name "#{node['magento']['db']['database']}" \
    --db_user "#{node['magento']['db']['username']}" \
    --db_pass "#{node['magento']['db']['password']}" \
    --url "#{url}" \
    --skip_url_validation \
    --session_save "#{node['magento']['app']['session_save']}" \
    --admin_frontname "#{node['magento']['app']['admin_frontname']}" \
    --use_rewrites "#{node['magento']['app']['use_rewrites']}" \
    --use_secure "#{node['magento']['app']['use_secure']}" \
    --secure_base_url "#{secure_url}" \
    --use_secure_admin "#{node['magento']['app']['user_secure_admin']}" \
    --admin_firstname "#{node['magento']['admin']['firstname']}" \
    --admin_lastname "#{node['magento']['admin']['lastname']}" \
    --admin_email "#{node['magento']['admin']['email']}" \
    --admin_username "#{node['magento']['admin']['user']}" \
    --admin_password "#{node['magento']['admin']['password']}"
    EOH

    log(install) { level :info }

    file "#{node['magento']['dir']}/app/etc/local.xml" do
      action :delete
    end

    bash "magento-install-site" do
      cwd node['magento']['dir']
      code <<-EOH
      cd #{node['magento']['dir']}/ && \
      #{install}
      EOH
    end

  else
    log("Magento is installed") { level :info }
  end

  include_recipe "chef-magento::config_local"

  if not_installed? && File.exists?("#{node['magento']['dir']}/app/etc/local.xml")
    log("There may be a problem with your setup as no admin users exist after install") { level :warn }
  end
else
  log("Magento install skipped as install file does not exist") { level :warn }
  log("File does not exist: #{node['magento']['dir']}/install.php") { level :info }
end
