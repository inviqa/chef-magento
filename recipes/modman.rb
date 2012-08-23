#
# Cookbook Name:: chef-magento
# Recipe:: modman
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

remote_file "#{Chef::Config[:file_cache_path]}/modman-installer" do
  source "https://raw.github.com/colinmollenhour/modman/master/modman-installer"
  mode "0655"
  action :create_if_missing
end

bash "Install Modman" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
  ./modman-installer \
  source ~/.profile
  EOH
end