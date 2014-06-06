#
# Cookbook Name:: chef-magento
# Recipe:: crontab
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

include_recipe "cron"

cron_d 'magento-cron' do
  minute  node['magento']['cronjob']['minute']
  command '/bin/sh <%= node['magento']['dir'] %>/cron.sh'
  user    node['magento']['cronjob']['user']
  mailto  node['magento']['admin']['email']
  action  :create
end
