include_recipe "chef-magento::modman"

chef_magento_modman "Init Modman" do
  project_path node['magento']['dir']
  action :init
end

chef_magento_modman "Mage-Test" do
  path "https://github.com/alistairstead/Mage-Test.git"
  project_path node['magento']['dir']
  action :clone
end

chef_magento_modman "Mage-Test" do
  project_path node['magento']['dir']
  action :deploycopy
end