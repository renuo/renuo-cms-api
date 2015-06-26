class CreateCredentialPairs < ActiveRecord::Migration
  def change
    create_table :credential_pairs do |t|
      t.string :private_api_key, null: false
      t.string :api_key, null: false

      t.timestamps null: false
    end
  end
end
