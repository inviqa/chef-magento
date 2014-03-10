# General settings
default['magento']['dir'] = "/var/www/magento.development.local/public"

default['magento']['app']['base_path'] = "public/"
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
default['magento']['app']['skip_updates'] = false


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
default['magento']['apache']['ssl']['protocols'] = [
    "TLSv1", "TLSv1.1", "TLSv1.2"
]
default['magento']['apache']['ssl']['ciphersuite'] = "ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH
+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS;"

default['magneto']['apache']['traceEnable'] = "off"

default['magento']['cronjob']['minute'] = "*/5"

default['magento']['cronjob']['minute'] = "*/5"
default['magento']['cronjob']['hour'] = "*"
default['magento']['cronjob']['name'] = "magento-crontab"
default['magento']['cronjob']['user'] = "root"

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
default['varnish']['cookies'] = ['currency', 'store']

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

# IP whitelisting for Magento stores for test-environments
#
# Enable and configure IPs to restrict access to only those IPs. Works in
# conjunction with default[:apache][:htpasswd], so that either can be used to
# grant access.
#
# Allow_domains lists (sub)domains that can be accessed regardless of IP
# restrictions. This can be used to serve static content via CDNs when IP
# restrictions are in place.
default['magento']['ip_whitelist']['enabled'] = false
default['magento']['ip_whitelist']['ips'] = Array.new
default['magento']['ip_whitelist']['allow_domains'] = Array.new

# Custom XML Snippet
default['magento']['global']['custom'] = ''

default['magento']['sample_data']['url'] = "http://www.magentocommerce.com/downloads/assets/1.2.0/magento-sample-data-1.2.0.tar.gz"

default['magento']['server']['aliases'] = Array.new
default['magento']['server']['static_domains'] = Array.new

default['extra_hostnames'] = Array.new
default['hosts']['entries'] = Array.new

# Capistrano setup
default['magento']['capistrano']['enabled'] = false
default['magento']['capistrano']["app_shared_dirs"] = ["/app/etc", "/sitemaps", "/media", "/var", "/staging"]
default['magento']['capistrano']["app_shared_files"] = ["/app/etc/local.xml"]
default['magento']['capistrano']["nfs_path"] = false
default['magento']['capistrano']["nfs_symlinks"] = ["/media", "/staging", "/sitemaps", "/var/locks"]
default['magento']['capistrano']["deploy_owner"] = "deploy"
default['magento']['capistrano']["deploy_group"] = "deploy"

::Chef::Node.send(:include, Opscode::OpenSSL::Password)

default_unless['magento']['db']['password'] = secure_password
default_unless['magento']['varnish']['perge_key'] = secure_password
default_unless['magento']['admin']['password'] = secure_password
