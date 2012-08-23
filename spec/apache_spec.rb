require 'chefspec'

describe 'chef-magento::apache' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'chef-magento::apache' }

  it 'should create a magento apache docroot directory' do
    chef_run.should create_directory '/var/www'
  end

  it 'should create a magento apache servername directory' do
    chef_run.should create_directory '/var/www/magento.development.local'
  end
end
