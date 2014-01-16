maintainer       "Alistair Stead"
maintainer_email "alistair.stead@inviqa.com"
license          "Apache 2.0"
description      "Installs/Configures Magento"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.3"

depends "php"
depends "git"
depends "mysql"
depends "database", "> 1.3.0"
suggests "apache2"
suggests "nginx"
suggests "memcached"
suggests "redisio"
suggests "chef-varnish"
suggests "solr"

%w{ ubuntu }.each do |os|
  supports os
end

recipe "chef-magento", "Install and configure Magento"
