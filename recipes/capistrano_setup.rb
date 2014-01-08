
root_dir = "#{node['magento']['apache']['docroot']}/#{node['magento']['apache']['servername']}"

%w{releases shared}.each do |dir|
    directory "#{root_dir}/#{dir}" do
        action :create
        recursive true
    end
end

node['magento']['capistrano']["app_shared_dirs"].each do |dir|
    directory "#{root_dir}/shared/#{node['magento']['app']['base_path']}/#{dir}" do
        action :create
        recursive true
    end
end

node['magento']['capistrano']["app_shared_files"].each do |file|
    directory File.dirname("#{root_dir}/shared/#{node['magento']['app']['base_path']}/#{file}") do
        action :create
        recursive true
    end

    file "#{root_dir}/shared/#{node['magento']['app']['base_path']}/#{file}" do
        action :create
    end
end

# ├── releases
# └── shared
#     ├── log
#     ├── pids
#     ├── public
#     │   ├── app
#     │   │   └── etc
#     │   │       └── local.xml
#     │   ├── blog
#     │   │   ├── wp-config.php
#     │   │   └── wp-content
#     │   │       └── uploads
#     │   ├── media
#     │   ├── sitemaps
#     │   ├── staging
#     │   └── var
#     └── system
#
#
#
# /var/www/missguided.co.uk/
# ├── current
# │   └── public
# ├── releases
# └── shared
#     └── public
#         ├── app
#         │   └── etc
#         │       └── local.xml
#         ├── media
#         ├── sitemaps
#         ├── staging
#         └── var


