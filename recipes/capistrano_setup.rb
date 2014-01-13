
root_dir = "#{node['magento']['apache']['docroot']}/#{node['magento']['apache']['servername']}"

deploy_owner = node['magento']['capistrano']["deploy_owner"]
deploy_group = node['magento']['capistrano']["deploy_owner"]

group deploy_group do
    action :create
end

user deploy_owner do
    action :create
    gid deploy_group
end

%w{releases shared}.each do |dir|
    directory "#{root_dir}/#{dir}" do
        recursive true
    end
end

node['magento']['capistrano']['app_shared_dirs'].each do |dir|
    full_path = "#{root_dir}/shared/#{node['magento']['app']['base_path']}/#{dir}"
    directory full_path do
        recursive true
        not_if do File.exists?(full_path) end
    end
end

node['magento']['capistrano']['app_shared_files'].each do |file|
    directory File.dirname("#{root_dir}/shared/#{node['magento']['app']['base_path']}/#{file}") do
        recursive true
    end

    file "#{root_dir}/shared/#{node['magento']['app']['base_path']}/#{file}" do
    end
end

bash "fix_deployment_permissions_recursively" do
    code "chown -R #{deploy_owner}:#{deploy_group} #{root_dir}"
end

if node['magento']['capistrano']['nfs_path']
    node['magento']['capistrano']['nfs_symlinks'].each do |symlink|
        full_path = "#{root_dir}/shared/#{node['magento']['app']['base_path']}/#{symlink}"
        directory full_path do
            action :delete
            not_if do File.symlink?(full_path) end
        end
        link full_path do
            link_type :symbolic
            to "#{node['magento']['capistrano']['nfs_path']}#{symlink}"
        end
    end
end
