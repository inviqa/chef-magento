require 'chefspec'
require 'fauxhai'

describe 'chef-magento::config_local' do
  before{ Fauxhai.mock(platform:'ubuntu') }

  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'chef-magento::config_local' }

  it 'should add magento completed local.xml file' do
    chef_run.should create_file '/var/www/magento.development.local/public/app/etc/local.xml'
  end
end
