class CredentialPair < ActiveRecord::Base
  validates :private_api_key, presence: true, uniqueness: true, length: { minimum: 8 }
  validates :api_key, presence: true
  validates :project_name, presence: true, uniqueness: true
end
