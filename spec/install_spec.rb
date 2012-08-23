require 'chefspec'

describe 'chef-magento::install' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'chef-magento::install' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
