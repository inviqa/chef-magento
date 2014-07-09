require 'chefspec'

describe 'chef-magento::apache' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'chef-magento::apache' }

  it 'should create a magento apache docroot directory' do
    expect(chef_run).to create_directory '/var/www'
  end

  it 'should create a magento apache servername directory' do
    expect(chef_run).to create_directory '/var/www/magento.development.local'
  end
  
  it 'should create a document root' do
    expect(chef_run).to create_directory '/var/www/magento.development.local/public'
  end

  it 'should create an apache vhost' do
    expect(chef_run).to create_file '/etc/apache2/sites-available/magento.development.local.conf'
  end

  it 'should create an apache vhost with basic auth if defined' do
    chef_run = ChefSpec::ChefRunner.new do |node|
      node.set['apache']['basic_username'] = true
    end
    chef_run.converge 'chef-magento::apache'
    expect(chef_run).to create_file_with_content '/etc/apache2/sites-available/magento.development.local.conf', 'AuthType Basic'
    expect(chef_run).to create_file_with_content '/etc/apache2/sites-available/magento.development.local.conf', 'Allow from all'
  end

  it 'should create an apache vhost with basic auth and exceptions if defined' do
    chef_run = ChefSpec::ChefRunner.new do |node|
      node.set['apache']['basic_username'] = true
      node.set['apache']['allow_from'] = [ '192.168.10.1', '192.168.10.2' ]
    end
    chef_run.converge 'chef-magento::apache'
    expect(chef_run).to create_file_with_content '/etc/apache2/sites-available/magento.development.local.conf', 'AuthType Basic'
    expect(chef_run).to create_file_with_content '/etc/apache2/sites-available/magento.development.local.conf', 'Satisfy Any'
    expect(chef_run).to create_file_with_content '/etc/apache2/sites-available/magento.development.local.conf', 'Allow from 192.168.10.1'
    expect(chef_run).to create_file_with_content '/etc/apache2/sites-available/magento.development.local.conf', 'Allow from 192.168.10.2'
  end
end
