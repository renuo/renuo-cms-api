class FixContentBlockDefaults < ActiveRecord::Migration
  def change
    ContentBlock.where(content_path: nil).update_all(content_path: '')
    ContentBlock.where(content: nil).update_all(content: '')
    ContentBlock.where(api_key: nil).update_all(api_key: '')

    change_column :content_blocks, :content, :text, default: '', null: false
    change_column :content_blocks, :content_path, :text, default: '', null: false
    change_column :content_blocks, :api_key, :string, default: '', null: false

    add_index :credential_pairs, [:api_key, :private_api_key], unique: true
  end
end
