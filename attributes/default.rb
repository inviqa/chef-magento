# General settings
default['magento']['dir'] = "/var/www/magento.development.local/public"

default['magento']['app']['locale'] = "en_GB"
default['magento']['app']['timezone'] = "Europe/London"
default['magento']['app']['currency'] = "GBP"
default['magento']['app']['session_save'] = "db" # files|db|memcache
default['magento']['app']['admin_frontname'] = "admin"
default['magento']['app']['use_rewrites'] = "yes"
default['magento']['app']['use_secure'] = "yes"
default['magento']['app']['use_secure_admin'] = "yes"
default['magento']['app']['multi_session_save'] = "db" # files|db|memcache|redis
default['magento']['app']['session_memcache_ip'] = "127.0.0.1"
default['magento']['app']['session_memcache_port'] = "11211"
default['magento']['app']['backend_cache'] = "file" # apc|memcached|xcache|file|Cm_Cache_Backend_Redis
default['magento']['app']['slow_backend'] = "database" # database|file
default['magento']['app']['backend_servers'] = Array.new


default['magento']['redis']['redis_class'] = 'Cm_Cache_Backend_Redis'
default['magento']['redis']['host'] = '127.0.0.1'
default['magento']['redis']['port'] = '6379'
default['magento']['redis']['timeout'] = '2.5'
default['magento']['redis']['database'] = '0'
default['magento']['redis']['full_page_cache_database'] = '1'
default['magento']['redis']['session_database'] = '2'
default['magento']['redis']['force_standalone'] = '0'
default['magento']['redis']['automatic_cleaning_factor'] = '0'
default['magento']['redis']['compress_data'] = '1'
default['magento']['redis']['compress_tags'] = '1'
default['magento']['redis']['compress_threshold'] = '2048'
default['magento']['redis']['compression_lib'] = 'gzip'

default['magento']['apache']['unsecure_port'] = "80"
default['magento']['apache']['secure_port'] = "443"
default['magento']['apache']['servername'] = "magento.development.local"
default['magento']['apache']['server_alias'] = Array.new
default['magento']['apache']['docroot'] = "/var/www"
default['magento']['apache']['path'] = "/public"
default['magento']['apache']['developer_mode'] = false
default['magento']['apache']['additional_rewites'] = ""
default['magento']['apache']['enable_mmap'] = "On"
default['magento']['apache']['enable_sendfile'] = "On"
default['magento']['apache']['ssl']['keyfile'] = "ssl/magento.key"
default['magento']['apache']['ssl']['certfile'] = "ssl/magento.pem"

default['magento']['sites'] = Array.new

default['magento']['php']['memory_limit'] = "512M"
default['magento']['php']['max_execution_time'] = "120"
default['magento']['php']['display_errors'] = "Off"
default['magento']['php']['html_errors'] = "Off"
default['magento']['php']['upload_max_filesize'] = '50M'

default['magento']['db']['host'] = "localhost"
default['magento']['db']['database'] = "magentodb"
default['magento']['db']['username'] = "magentouser"
default['magento']['db']['read']['host'] = "localhost"
default['magento']['db']['write']['host'] = "localhost"

default['magento']['admin']['firstname'] = "Chef"
default['magento']['admin']['lastname'] = "Admin"
default['magento']['admin']['email'] = "chef@magento.com"
default['magento']['admin']['user'] = "chef"
default['magento']['admin']['password'] = '123123pass'

default['magento']['varnish']['backend_servers'] = [
    {
        "name" => "web1",
        "ip" => "127.0.0.1"
    }
]
default['magento']['varnish']['trusted_servers'] = [
    "127.0.0.1"
]
default['magento']['varnish']['ttl_for_static_files'] = '30d'

# Custom XML Snippet
default['magento']['global']['custom'] = ''

default['magento']['sample_data']['url'] = "http://www.magentocommerce.com/downloads/assets/1.2.0/magento-sample-data-1.2.0.tar.gz"

default['magento']['server']['aliases'] = Array.new
default['magento']['server']['static_domains'] = Array.new

::Chef::Node.send(:include, Opscode::OpenSSL::Password)

default_unless['magento']['db']['password'] = secure_password
default_unless['magento']['varnish']['perge_key'] = secure_password
default_unless['magento']['admin']['password'] = secure_password

#----------------------------------

default['magento']['dir'] = "/var/www/magento.development.local/public"

default['ssl'] = 'on'
default['magento']['nginx']['basic_authentication'] = 'on'

default['magento']['nginx']['ssl']['keyfile']   = 'magento.key'
default['magento']['nginx']['ssl']['certfile']  = 'magento.crt'

default['magento']['nginx']['unsecure_port']                    = '80'
default['magento']['nginx']['secure_port']                      = '443'
default['magento']['nginx']['servername']                       = 'magento.development.local'
default['magento']['nginx']['developer_mode']                   = false
default['magento']['nginx']['additional_config_path']           = '/mnt/magento.development.local/config.d'
default['magento']['nginx']['docroot']                          = "/var/www"
default['magento']['nginx']['storecode_mapping']                = [
    "magento.development.local default",
]

default['nginx']['multi_accept']                = 'on'
default['nginx']['server_tokens']               = 'off'
default['nginx']['tcp_nopush']                  = 'on'
default['nginx']['tcp_nodelay']                 = 'on'
default['nginx']['gzip_vary']                   = 'on'
default['nginx']['gzip_buffers']                = '16 8k'
default['nginx']['gzip_min_length']             = '1024'
default['nginx']['keepalive_timeout']           = '10'
default['nginx']['fastcgi_connection_timeout']  = '65'
default['nginx']['fastcgi_send_timeout']        = '7200'
default['nginx']['fastcgi_read_timeout']        = '7200'
default['nginx']['ssl_dir']                     = "#{node['nginx']['dir']}/ssl"

default['php-fpm']['dir'] = "/etc/php-fpm.d"
default['php-fpm']['process_manager']['type'] = "dynamic"
default['php-fpm']['process_manager']['max_children'] = "50"
default['php-fpm']['process_manager']['start_servers'] = "5"
default['php-fpm']['process_manager']['min_spare_servers'] = "5"
default['php-fpm']['process_manager']['max_spare_servers'] = "35"
default['php-fpm']['process_manager']['max_requests'] = "0"

case node['platform_family']
when 'rhel', 'fedora'
    if node['platform_version'].to_f < 6
        default['php-fpm']['packages'] = %w{ php53u-fpm }
    else
        default['php-fpm']['packages'] = %w{ php-fpm }
    end
else
    default['php-fpm']['packages'] = %w{ php5-fpm }
end

default['magento']['php']['memory_limit'] = "512M"
default['magento']['php']['max_execution_time'] = "120"
default['magento']['php']['display_errors'] = "Off"
default['magento']['php']['html_errors'] = "Off"
default['magento']['php']['upload_max_filesize'] = '50M'

default['magento']['varnish']['backend_servers'] = [
    {
        "name" => "web1",
        "ip" => "127.0.0.1"
    }
]
default['magento']['varnish']['trusted_servers'] = [
    "127.0.0.1"
]
default['magento']['varnish']['ttl_for_static_files'] = '30d'

default['webserver_type'] = 'apache'
