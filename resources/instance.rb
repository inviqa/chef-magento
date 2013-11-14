actions :configure

def initialize(*args)
  super
  @action = :configure
end

attribute :template_cookbook, :kind_of => String
attribute :instance, :kind_of => String
attribute :environment, :kind_of => String
attribute :dir, :kind_of => String
attribute :apache_document_root, :kind_of => String
attribute :servername, :kind_of => String
attribute :data_bag_folder, :kind_of => String
attribute :data_bag_item, :kind_of => String
attribute :magento, :kind_of => Hash, :default => {}