require 'chefspec'
require 'fauxhai'

describe 'chef-magento::varnish' do

  before{ Fauxhai.mock(platform:'ubuntu') }

  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'chef-magento::varnish' }

  it 'should add default.vcl tuned for Magento' do
    chef_run.should create_file '/etc/varnish/default.vcl'
  end
  
end
