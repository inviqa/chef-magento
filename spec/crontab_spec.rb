require 'chefspec'

describe 'chef-magento::crontab' do
  context 'default settings are provided' do
    let (:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'should set up magento cron' do
      expect(chef_run).to create_cron_d("magento-crontab")
    end

    it 'should use the correct cron script' do
      expect(chef_run).to create_cron_d("magento-crontab").with(:command => "/var/www/magento.development.local/public/cron.sh")
    end

    it 'should run every 20 minutes per hour' do
      expect(chef_run).to create_cron_d("magento-crontab").with(:minute => "*/5")
    end

    it 'should run every hour per day' do
      expect(chef_run).to create_cron_d("magento-crontab").with(:hour => "*")
    end

    it 'should run as root' do
      expect(chef_run).to create_cron_d("magento-crontab").with(:user => "root")
    end
  end

  context 'cron is disabled' do
    let (:chef_run) {
      ChefSpec::SoloRunner.new do |node|
        node.set['magento']['cronjob']['enabled'] = false
      end.converge(described_recipe)
    }

    it 'should disable the cron job' do
      expect(chef_run).to delete_cron_d('magento-crontab')
    end
  end
end
