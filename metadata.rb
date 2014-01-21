maintainer       "Alistair Stead"
maintainer_email "alistair.stead@inviqa.com"
license          "Apache 2.0"
description      "Installs/Configures Magento"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.2"

depends "php"
depends "chef-php-extra"
depends "git"
depends "mysql"
depends "database", "> 1.3.0"
depends "apache2"
depends "memcached"
depends "cron", "= 1.2.6"
# depends "redis" # This Opscode cookbook has an error
suggests "chef-varnish"
suggests "solr"

%w{ ubuntu }.each do |os|
  supports os
end

recipe "chef-magento", "Install and configure Magento"
