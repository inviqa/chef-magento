action :init do
  execute "Initialize project with modman #{new_resource.name}" do
    cwd new_resource.project_path
    user "root"
    command "$HOME/bin/modman init"
    not_if do
      ::File.exists?("#{new_resource.project_path}/.modman")
    end
  end
  new_resource.updated_by_last_action(true)
end

action :updateall do
  execute "Update all modules managed with modman using the appropriate VCS #{new_resource.name}" do
    cwd new_resource.project_path
    user "root"
    command "$HOME/bin/modman update-all"
    only_if do
      ::File.exists?("#{new_resource.project_path}/.modman")
    end
  end
  new_resource.updated_by_last_action(true)
end

action :deployall do
  execute "Update the symlinks for all modules managed with modman #{new_resource.name}" do
    cwd new_resource.project_path
    user "root"
    command "$HOME/bin/modman deploy-all"
    only_if do
      ::File.exists?("#{new_resource.project_path}/.modman")
    end
  end
  new_resource.updated_by_last_action(true)
end

action :repair do
  execute "Repair the symlinks for all modules managed with modman no VCS update #{new_resource.name}" do
    cwd new_resource.project_path
    user "root"
    command "$HOME/bin/modman repair"
    only_if do
      ::File.exists?("#{new_resource.project_path}/.modman")
    end
  end
  new_resource.updated_by_last_action(true)
end

action :clean do
  execute "Remove broken symlinks for all modules managed with modman #{new_resource.name}" do
    cwd new_resource.project_path
    user "root"
    command "$HOME/bin/modman clean"
    only_if do
      ::File.exists?("#{new_resource.project_path}/.modman")
    end
  end
  new_resource.updated_by_last_action(true)
end

action :checkout do
  execute "Checkout external module with modman from an SVN repos #{new_resource.name}" do
    cwd new_resource.project_path
    user "root"
    command "$HOME/bin/modman checkout #{new_resource.path}"
    not_if do
      `cd #{new_resource.project_path} && modman list | grep '#{new_resource.name}'` != ''
    end
  end
  new_resource.updated_by_last_action(true)
end

action :clone do
  execute "Clone external module with modman from a Git repos #{new_resource.name}" do
    cwd new_resource.project_path
    user "root"
    command "$HOME/bin/modman clone #{new_resource.path}"
    not_if do
      `cd #{new_resource.project_path} && modman list | grep '#{new_resource.name}'` != ''
    end
  end
  new_resource.updated_by_last_action(true)
end

action :link do
  execute "Link local file system module with modman #{new_resource.name}" do
    cwd new_resource.project_path
    user "root"
    command "$HOME/bin/modman link #{new_resource.path} --force"
    only_if do
      ::File.exists?("#{new_resource.project_path}/.modman")
    end
  end
  new_resource.updated_by_last_action(true)
end

action :update do
  execute "Update a single module managed with modman using the appropriate VCS #{new_resource.name}" do
    cwd new_resource.project_path
    user "root"
    command "$HOME/bin/modman update #{new_resource.name}"
    only_if do
      ::File.exists?("#{new_resource.project_path}/.modman")
    end
  end
  new_resource.updated_by_last_action(true)
end

action :deploy do
  execute "Deploy a single module managed with modman #{new_resource.name}" do
    cwd new_resource.project_path
    user "root"
    command "$HOME/bin/modman deploy #{new_resource.name}"
    only_if do
      ::File.exists?("#{new_resource.project_path}/.modman")
    end
  end
  new_resource.updated_by_last_action(true)
end

action :deploycopy do
  execute "Deploy a single module managed with modman #{new_resource.name}" do
    cwd new_resource.project_path
    user "root"
    command "$HOME/bin/modman deploy #{new_resource.name} --force --copy"
    only_if do
      ::File.exists?("#{new_resource.project_path}/.modman")
    end
  end
  new_resource.updated_by_last_action(true)
end