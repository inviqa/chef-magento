define :magento_site do
  instance_resource params[:instance_resource]

  site_data = {
    "servername" => @params[:servername],
    "run_code" => @params[:run_code],
    "additional_rewrite" => @params[:additional_rewrite],
    "server_alias" => @params[:server_alias]
  }

  def configure_apache(servername, ssl)
    web_app servername do
      template "apache-vhost.conf.erb"
      ssl ssl
      apache instance_resource.magento[:apache]
      php instance_resource.magento[:php]
      site site_data
      magento instance_resource.magento
      notifies :reload, resources("service[apache2]"), :delayed
    end
  end

  configure_apache(@params[:servername], false)
  configure_apache("#{@params[:servername]}.ssl", true)

end