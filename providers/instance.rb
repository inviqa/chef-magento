# recursive merge key vlaue
def merge_deep(node, data)
  data.each do |key, value|
      if value.class == Hash
          merge_deep node[key], value
      else
          node[key] = value
      end
  end
end

#
def merge_data_bag(data_bag_folder, data_bag_item)
  data_bag_data = Chef::EncryptedDataBagItem.load(
    data_bag_folder, data_bag_item
  ).to_hash

  data_bag_data.delete('id')
  merge_deep node.set, data_bag_data
end

#
def merge_custom_data()
  custom_data = {
    "magento" => {
      "instance" => new_resource.instance,
      "environment" => new_resource.environment,
      "dir" => new_resource.dir,
      "apache_document_root" => new_resource.apache_document_root,
      "apache" => {
        "servername" => new_resource.servername,
        "newrelic_name" => new_resource.newrelic_name,
        "run_code" => "",
        "additional_rewites" => "",
        "server_alias" => []
      }
    }
  }

  # merge custom information about an instance
  merge_deep node.set, custom_data
end

# Configure magento instance
action :configure do

  # merge custom information about an instance
  merge_custom_data

  # merge data bag item
  merge_data_bag(new_resource.data_bag_folder, new_resource.data_bag_item)

  # Update instance attribute value
  new_resource.magento = node[:magento]
  new_resource.updated_by_last_action(true)

  # Create user group.
  group node[:capistrano][:deploy_group] do
    action :create
  end

  # Create user and set user group.
  user node[:capistrano][:deploy_user] do
    gid node[:capistrano][:deploy_group]
    supports :manage_home => true
  end

  # Create sites directory with correct user and group
  directory node[:capistrano][:sites_dir] do
    owner node[:capistrano][:deploy_user]
    group node[:capistrano][:deploy_group]
    mode 00755
    action :create
    recursive true
  end

  # Create directories under sites with correct user and group
  current = "#{node[:capistrano][:sites_dir]}"
  "#{node[:magento][:environment]}/#{node[:capistrano][:shared_dir]}/Magento/app/etc".split('/').each do |dir|
    current = "#{current}/#{dir}"
    directory current do
      owner node[:capistrano][:deploy_user]
      group node[:capistrano][:deploy_group]
      mode 00755
      action :create
    end
  end

  # create local xml on a shared dir or magento dir
  if defined?(node[:capistrano][:shared_dir])
    capistrano = node[:capistrano]
    template "#{capistrano[:sites_dir]}/#{node[:magento][:environment]}/#{capistrano[:shared_dir]}/Magento/app/etc/local.xml" do
      source "local.xml.erb"
      mode 0644
      owner node[:capistrano][:deploy_user]
      group node[:capistrano][:deploy_group]
      variables({
        :magento => node[:magento]
      })
    end
  else
    template "#{node[:magento][:dir]}/app/etc/local.xml" do
      cookbook new_resource.template_cookbook
      source "local.xml.erb"
      mode 0644
      variables({
        :magento => node[:magento]
      })
    end
  end

  template "/etc/cron.d/#{node[:magento][:environment]}" do
    source "magento-crontab.erb"
    mode 0644
    variables({
      :user => "root",
      :magento => node[:magento]
    })
  end

  if defined? node['magento']['apache']['ssl']['data-bag']
    ssl_data_bag = Chef::EncryptedDataBagItem.load(
      node['magento']['apache']['ssl']['data-bag'],
      node['magento']['apache']['ssl']['data-bag-item'])

    ['certfile', 'certchainfile', 'keyfile'].each do |filekey|
      file filename do
        content ssl_data_bag[node['magento']['apache']['ssl'][filekey]]
        mode 0600
      end
    end
  end

  web_app new_resource.servername do
    cookbook "chef-magento"
    template "apache-vhost.conf.erb"
    ssl false
    apache node[:apache]
    php node[:magento][:php]
    site node[:magento][:apache]
    magento node[:magento]
    notifies :reload, resources("service[apache2]"), :delayed
  end

  web_app "#{new_resource.servername}.ssl" do
    cookbook "chef-magento"
    template "apache-vhost.conf.erb"
    ssl true
    apache node[:apache]
    php node[:magento][:php]
    site node[:magento][:apache]
    magento node[:magento]
    notifies :reload, resources("service[apache2]"), :delayed
  end

  %w{default 000-default}.each do |site|
    apache_site site do
      enable false
      notifies :reload, resources("service[apache2]"), :delayed
    end
  end
end