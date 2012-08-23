require 'chefspec'

describe 'chef-magento::magetool' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'chef-magento::magetool' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
