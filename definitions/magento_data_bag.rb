define :magento_data_bag do
  # recursive merge key vlaue
  def merge_deep(node, data)
      data.each do |key, value|
          if value.class == Hash
              merge_deep node[key], value
          else
              node[key] = value
          end
      end
  end

  data_bag_data = Chef::EncryptedDataBagItem.load(
      params[:data_bag_folder],
      params[:data_bag_item]
  ).to_hash

  data_bag_data.delete('id')
  merge_deep node.set, data_bag_data
end