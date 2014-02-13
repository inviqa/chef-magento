directory "#{node['nginx']['dir']}/conf.d/" do
  owner "root"
  group "root"
  mode 00755
  recursive true
end

directory "#{node['nginx']['dir']}/sites-available/" do
  owner "root"
  group "root"
  mode 00755
  recursive true
end

include_recipe 'nginx::http_ssl_module'
include_recipe 'nginx'
include_recipe 'nginx::http_stub_status_module'

include_recipe "php"

if node['platform_version'].to_f < 6
  packages = %w{ php53u-fpm }
else
  packages = %w{ php-fpm }
end



pkgs = value_for_platform(
  [ "centos", "redhat", "fedora" ] => {
    "default" => packages
  },
  [ "debian", "ubuntu" ] => {
    "default" => %w{ php5-fpm }
  }
)

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

service "php-fpm" do
  supports :restart => true
  restart_command "/etc/init.d/php-fpm restart"
  action :nothing
end

template "#{node['php-fpm']['dir']}/www.conf" do
  source "www.conf.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, 'service[php-fpm]'
end

if ['on', 'On', 'true'].include?"#{node['ssl']}"
    directory node['nginx']['ssl_dir'] do
        mode 00755
        owner node['nginx']['user']
        action :create
        recursive true
    end

    bash "install_ssl_certification" do
        code <<-EOH
            openssl req -new -x509 -nodes -batch -days 999 -out "#{node['nginx']['ssl_dir']}/#{node['magento']['nginx']['ssl']['certfile']}" -keyout "#{node['nginx']['ssl_dir']}/#{node['magento']['nginx']['ssl']['keyfile']}"
            chmod 600 "#{node['nginx']['ssl_dir']}/#{node['magento']['nginx']['ssl']['keyfile']}"
        EOH
    end
end

template "#{node['nginx']['dir']}/nginx.conf" do
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :reload, 'service[nginx]'
end

template "#{node['nginx']['dir']}/conf.d/default.conf" do
  source "conf.d/default.conf.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :reload, 'service[nginx]'
end

template "#{node['nginx']['dir']}/fastcgi_params" do
  source "fastcgi_params.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :reload, 'service[nginx]'
end

