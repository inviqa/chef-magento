define :install_mage do

    dir = params[:dir]
    servername = params[:servername]
    databasename = params[:databasename]

    install = <<-EOH
php -f install.php -- \
--license_agreement_accepted "yes" \
--locale "#{node[:magento][:app][:locale]}" \
--timezone "#{node[:magento][:app][:timezone]}" \
--default_currency "#{node[:magento][:db][:currency]}" \
--db_host "#{node[:magento][:db][:host]}" \
--db_name "#{databasename}" \
--db_user "#{node[:magento][:db][:username]}" \
--db_pass "#{node[:magento][:db][:password]}" \
--url "http://#{servername}/" \
--skip_url_validation \
--session_save "#{node[:magento][:app][:session_save]}" \
--admin_frontname "#{node[:magento][:app][:admin_frontname]}" \
--use_rewrites "#{node[:magento][:app][:use_rewrites]}" \
--use_secure "#{node[:magento][:app][:use_secure]}" \
--secure_base_url "https://#{servername}/" \
--use_secure_admin "#{node[:magento][:app][:user_secure_admin]}" \
--admin_firstname "#{node[:magento][:admin][:firstname]}" \
--admin_lastname "#{node[:magento][:admin][:lastname]}" \
--admin_email "#{node[:magento][:admin][:email]}" \
--admin_username "#{node[:magento][:admin][:user]}" \
--admin_password "#{node[:magento][:admin][:password]}"
EOH

    bash "magento-install-site" do
        cwd "#{dir}/"
        code <<-EOH
cd #{dir}/ && #{install}
EOH
    end

    indexsite = <<-EOH
php -f shell/indexer.php -- reindexall
EOH

    bash "magento-index-site" do
        cwd "#{node[:magento][:dir]}/"
        code <<-EOH
cd #{node[:magento][:dir]}/ && #{indexsite}
EOH
    end
end