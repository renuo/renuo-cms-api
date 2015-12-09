class AddProjectNameToCredentialPair < ActiveRecord::Migration
  def change
    add_column :credential_pairs, :project_name, :string, null: false, default: ''
    CredentialPair.all.each do |c|
      c.update(project_name: "unknown-please-update-me-#{Kernel.rand(1_000_000_000..2_000_000_000).to_s(16)}")
    end
  end
end
