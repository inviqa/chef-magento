include_recipe "chef-magento::modman"

chef_magento_modman "Init Modman" do
  project_path node['magento']['dir']
  action :init
end

chef_magento_modman "Cm_RedisSession" do
  path "https://github.com/colinmollenhour/Cm_RedisSession.git"
  project_path node['magento']['dir']
  action :clone
end

chef_magento_modman "Cm_RedisSession" do
  project_path node['magento']['dir']
  action :deploycopy
end