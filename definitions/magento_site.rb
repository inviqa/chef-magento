define :magento_site do
  site = params[:site]

  web_app site['servername'] do
    template "apache-vhost.conf.erb"
    ssl false
    apache node['apache']
    php node['magento']['php']
    site site
    magento node['magento']
    notifies :reload, resources("service[apache2]"), :delayed
  end

  web_app "#{site['servername']}.ssl" do
    template "apache-vhost.conf.erb"
    ssl true
    apache node['apache']
    php node['magento']['php']
    site site
    magento node['magento']
    notifies :reload, resources("service[apache2]"), :delayed
  end
end
