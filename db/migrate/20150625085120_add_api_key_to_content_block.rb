class AddApiKeyToContentBlock < ActiveRecord::Migration
  def change
    add_column :content_blocks, :api_key, :string
  end
end
