require 'digest/sha1'
require 'base64'
require 'time'
require 'openssl'
require 'uri'

define :download_mage, :version => "1.5.0.0" do

    dir = params[:dir]

    def string_to_sign(req, expires, uri)
        "#{req}\n\n\n#{expires}\n/mage-versions#{uri}"
    end

    def encode_signature(key, string)
        sig = OpenSSL::HMAC.digest('sha1', key, string)
        URI.escape(Base64.b64encode(sig).gsub(/\n/,''), Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end

    s3Url = "http://mage-versions.s3.amazonaws.com"
    uri = "/magento-#{params[:version]}.tar.gz"
    accessKeyId = 'AKIAJX4YTX5C3DE6WGWQ'
    secretAccessKey = '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'

    expires = Time.now.to_i + 600
    stringToSign = string_to_sign('GET', expires, uri)
    signature = encode_signature(secretAccessKey, stringToSign)

    url = "#{s3Url}#{uri}?AWSAccessKeyId=#{accessKeyId}&Signature=#{signature}&Expires=#{expires}"

    remote_file "#{Chef::Config[:file_cache_path]}/magento-#{params[:version]}.tar.gz" do
      source "#{url}"
      mode "0644"
    end

    directory "#{dir}" do
        owner "root"
        group "root"
        mode "0755"
        action :create
        recursive true
    end

    execute "untar-magento" do
        cwd dir
        command "tar -zxvf #{Chef::Config[:file_cache_path]}/magento-#{params[:version]}.tar.gz"
    end
end