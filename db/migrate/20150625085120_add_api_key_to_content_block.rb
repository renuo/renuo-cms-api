class AddApiKeyToContentBlock < ActiveRecord::Migration
  def change
    add_column :content_blocks, :api_key, :string

    add_index :content_blocks, :api_key
    add_index(:content_blocks, [:api_key, :content_path], unique: true)
  end
end
