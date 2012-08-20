require 'chefspec'

describe 'chef-magento::sample_data' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'chef-magento::sample_data' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
