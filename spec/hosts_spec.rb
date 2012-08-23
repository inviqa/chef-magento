require 'chefspec'
require 'fauxhai'

describe 'chef-magento::hosts' do

  before{ Fauxhai.mock(platform:'ubuntu') }

  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'chef-magento::hosts' }

  it 'should add magento FQDN to the hosts file' do
    chef_run.should create_file_with_content '/etc/hosts', 'magento.development.local'
  end
end
