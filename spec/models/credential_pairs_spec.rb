require 'rails_helper'

RSpec.describe CredentialPair, type: :model do
  it 'creates a credential pair' do
    credential_pair = build(:credential_pair)
    expect(credential_pair.api_key).to be_truthy
    expect(credential_pair.private_api_key).to be_truthy
    expect(credential_pair.project_name).to be_truthy
  end

  it 'validates the credential pair project name' do
    credential_pair = build(:credential_pair)
    expect(credential_pair.valid?).to be_truthy
    credential_pair.project_name = ''
    expect(credential_pair.valid?).to be_falsey
  end
end
