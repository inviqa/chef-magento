#
# Cookbook Name:: chef-magento
# Recipe:: magetool
#
# Copyright 2012, Alistair Stead
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "chef-php-extra::zendframework"

mt = php_pear_channel "pear.magetool.co.uk" do
  action :discover
end

php_pear "magetool" do
  preferred_state "beta"
  channel mt.channel_name
  action :install
end

# This overwrites whatever was in .zf.ini beforehand, and also is
# hardcoded to the "user" user.  Is there any easy way to "push" onto
# the basicloader.classes array?

filePath = "/home/user/.zf.ini"
user = "user"

if File.exists?("/home/vagrant/")
    filePath = "/home/vagrant/.zf.ini" 
    user = "vagrant" 
end

file filePath do
  owner user
  mode "0644"
  content [
    "php.include_path = \".:/usr/share/php:/usr/share/pear\"",
    "basicloader.classes.0 = \"MageTool_Tool_Manifest\""
  ].join("\n")
end