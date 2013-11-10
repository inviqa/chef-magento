# magento_instance Definition
define :magento_instance do

  node.override["magento"]["environment"] = params[:environment]
  node.override["magento"]["dir"] = params[:dir]
  node.override["magento"]["apache_document_root"] = params[:apache_document_root]
  node.override["magento"]["apache"]["servername"] = params[:servername]

  data_bag_data = Chef::EncryptedDataBagItem.load("#{params[:data_bag_folder]}", "#{params[:data_bag_item]}").to_hash
  data_bag_data["magento"]["db"].each do |key, value|
    node.override["magento"]["db"][key] = value
  end

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

  web_app "#{node[:magento][:apache][:servername]}" do
    cookbook "chef-magento"
    template "apache-vhost.conf.erb"
    ssl false
    apache node[:apache]
    php node[:magento][:php]
    site node[:magento][:apache]
    magento node[:magento]
    notifies :reload, resources("service[apache2]"), :delayed
  end

  web_app "#{node[:magento][:apache][:servername]}.ssl" do
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