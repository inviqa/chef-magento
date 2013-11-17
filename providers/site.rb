# Configure magento instance
action :configure do

  def merge_deep(node, data)
    data.each do |key, value|
        if value.class == Hash
            merge_deep node[key], value
        else
            node[key] = value
        end
    end
  end

  site_data = {
    "magento" => {
      "dir" => new_resource.docroot
    },
    "site" => {
      "servername" => new_resource.servername,
      "run_code" => new_resource.run_code,
      "additional_rewites" => new_resource.additional_rewites,
      "server_alias" => new_resource.server_alias,
      "newrelic_name" => new_resource.newrelic_name
    }
  }
  merge_deep node.set, site_data

  def configure_apache(servername, is_ssl)
    web_app servername do
      cookbook "chef-magento"
      template "apache-vhost.conf.erb"
      ssl is_ssl
      apache node[:apache]
      php node[:magento][:php]
      site node[:site]
      magento node[:magento]
      notifies :reload, resources("service[apache2]"), :delayed
    end
  end

  configure_apache(new_resource.servername, false)
  configure_apache("#{new_resource.servername}.ssl", true)
end