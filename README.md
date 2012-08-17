# Description


# Requirements

Chef 0.10.0 or higher required (for Chef environment use).

## Platform

* Debian, Ubuntu
* CentOS, Red Hat, Fedora

Your basebox must have the `mysql` gem installed.

## Cookbooks

The following Opscode cookbooks are dependencies:

* php
* mysql
* database
* apache2
* memcached

# Attributes

* `node["xhprof"]["db"]["database"]` = The name of the database used to store profiling data, defaults to `xhprof`.

# Recipes

## apache

Installs and Configures apache vhosts for your Magento project

## config_local

Creates a `local.xml` configuration file that connects Magento to the correct database of caching server.

## crontab

Creates and installs a crontab entry to configure the correct execution of Magento cron tasks

## default

Runs the following recipes:

* chef-magento::apache
* chef-magento::php

# Usage



# License and Author

Author:: Alistair Stead (alistair@inviqa.com)

Copyright 2012, Inviqa

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

