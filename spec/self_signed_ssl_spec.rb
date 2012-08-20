require 'chefspec'

describe 'chef-magento::self_signed_ssl' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'chef-magento::self_signed_ssl' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
