require 'chefspec'

describe 'chef-magento::crontab' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'chef-magento::crontab' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
