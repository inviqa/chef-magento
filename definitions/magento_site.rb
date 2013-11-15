define :magento_site do
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
    "site" => {
      "servername" => @params[:servername],
      "run_code" => @params[:run_code],
      "additional_rewites" => @params[:additional_rewites],
      "server_alias" => @params[:server_alias],
      "newrelic_name" => @params[:newrelic_name]
    }
  }
  merge_deep node.set, site_data

  def configure_apache(servername, is_ssl, resource)
    web_app servername do
      cookbook "chef-magento"
      template "apache-vhost.conf.erb"
      ssl is_ssl
      apache node[:apache]
      php resource.magento[:php]
      site node[:site]
      magento resource.magento
      notifies :reload, resources("service[apache2]"), :delayed
    end
  end

  configure_apache(@params[:servername], false, @params[:instance_resource])
  configure_apache("#{@params[:servername]}.ssl", true, @params[:instance_resource])
end