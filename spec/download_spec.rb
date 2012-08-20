require 'chefspec'

describe 'chef-magento::download' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'chef-magento::download' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
