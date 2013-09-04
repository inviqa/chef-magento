maintainer       "Alistair Stead"
maintainer_email "alistair.stead@inviqa.com"
license          "Apache 2.0"
description      "Installs/Configures Magento"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "php"
depends "chef-php-extra"
depends "git"
depends "mysql"
depends "database"
depends "apache2"
depends "memcached"
# depends "redis" # This Opscode cookbook has an error
depends "chef-varnish"
depends "chef-magento"
depends "solr"
depends "cron", "= 1.2.6"

%w{ ubuntu }.each do |os|
  supports os
end

recipe "chef-magento", "Install and configure Magento"
