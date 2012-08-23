require 'chefspec'

describe 'chef-magento::php' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'chef-magento::php' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
