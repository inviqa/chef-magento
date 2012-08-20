require 'chefspec'

describe 'chef-magento::default' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'chef-magento::default' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
