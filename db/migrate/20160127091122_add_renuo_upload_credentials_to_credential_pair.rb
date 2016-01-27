class AddRenuoUploadCredentialsToCredentialPair < ActiveRecord::Migration
  def change
    add_column :credential_pairs, :renuo_upload_api_key, :string, null: false, default: ''
    add_column :credential_pairs, :renuo_upload_signing_url, :string, null: false, default: ''
  end
end
