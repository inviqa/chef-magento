# General settings
default[:magento][:dir] = "/var/www/magento.development.local/public"

default[:magento][:app][:locale] = "en_GB"
default[:magento][:app][:timezone] = "Europe/London"
default[:magento][:app][:currency] = "GBP"
default[:magento][:app][:session_save] = "db" # files|db|memcache
default[:magento][:app][:admin_frontname] = "admin"
default[:magento][:app][:use_rewrites] = "yes"
default[:magento][:app][:use_secure] = "yes"
default[:magento][:app][:use_secure_admin] = "yes"
default[:magento][:app][:multi_session_save] = "db" # files|db|memcache
default[:magento][:app][:session_memcache_ip] = "127.0.0.1"
default[:magento][:app][:session_memcache_port] = "11211"
default[:magento][:app][:backend_cache] = "file" # apc|memcached|xcache|file
default[:magento][:app][:slow_backend] = "database" # database|file
default[:magento][:app][:backend_servers] = Array.new

default[:magento][:apache][:unsecure_port] = "80"
default[:magento][:apache][:secure_port] = "443"
default[:magento][:apache][:servername] = "magento.development.local"
default[:magento][:apache][:server_alias] = Array.new
default[:magento][:apache][:docroot] = "/var/www"
default[:magento][:apache][:path] = "/public"
default[:magento][:apache][:developer_mode] = "false"
default[:magento][:apache][:additional_config_path] = ""
default[:magento][:apache][:additional_rewites] = ""


default[:magento][:php][:memory_limit] = "512M"
default[:magento][:php][:max_execution_time] = "120"
default[:magento][:php][:display_errors] = "Off"
default[:magento][:php][:html_errors] = "Off"
default[:magento][:php][:upload_max_filesize] = '50M'

default[:magento][:db][:host] = "localhost"
default[:magento][:db][:database] = "magentodb"
default[:magento][:db][:username] = "magentouser"
default[:magento][:db][:read][:host] = "localhost"
default[:magento][:db][:write][:host] = "localhost"

default[:magento][:admin][:firstname] = "Chef"
default[:magento][:admin][:lastname] = "Admin"
default[:magento][:admin][:email] = "chef@magento.com"
default[:magento][:admin][:user] = "chef"
default[:magento][:admin][:password] = '123123pass'

default[:magento][:varnish][:backend_servers] = [
    {
        "name" => "web1",
        "ip" => "127.0.0.1"
    }
]
default[:magento][:varnish][:trusted_servers] = [
    "127.0.0.1"
]


# Custom XML Snippet
default[:magento][:global][:custom] = ''

default[:magento][:sample_data][:url] = "http://www.magentocommerce.com/downloads/assets/1.2.0/magento-sample-data-1.2.0.tar.gz"

default[:magento][:server][:aliases] = Array.new
default[:magento][:server][:static_domains] = Array.new

::Chef::Node.send(:include, Opscode::OpenSSL::Password)

default_unless[:magento][:db][:password] = secure_password
default_unless[:magento][:varnish][:perge_key] = secure_password
default_unless[:magento][:admin][:password] = secure_password