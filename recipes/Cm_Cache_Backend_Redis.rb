include_recipe "chef-magento::modman"

chef_magento_modman "Init Modman" do
  project_path node['magento']['dir']
  action :init
end

chef_magento_modman "Cm_Cache_Backend_Redis" do
  path "https://github.com/colinmollenhour/Cm_Cache_Backend_Redis.git"
  project_path node['magento']['dir']
  action :clone
end

chef_magento_modman "Cm_Cache_Backend_Redis" do
  project_path node['magento']['dir']
  action :deploycopy
end