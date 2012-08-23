require 'chefspec'

describe 'chef-magento::mysql' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'chef-magento::mysql' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
