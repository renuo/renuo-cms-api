class CredentialPair < ActiveRecord::Base
  validates :private_api_key, presence: true, uniqueness: true
  validates :api_key, presence: true, uniqueness: true
end
