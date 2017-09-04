# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CredentialPair, type: :model do
  it 'creates a credential pair' do
    credential_pair = build(:credential_pair)
    expect(credential_pair.api_key).to be_truthy
    expect(credential_pair.private_api_key).to be_truthy
    expect(credential_pair.project_name).to start_with('project-')
    expect(credential_pair.renuo_upload_api_key).to eq('87VJCHauQZuTyY92JOjy0c6tW')
    expect(credential_pair.renuo_upload_signing_url).to eq('https://some.host')
  end

  it 'validates the credential pair project name' do
    credential_pair = build(:credential_pair)
    expect(credential_pair.valid?).to be_truthy
    credential_pair.project_name = ''
    expect(credential_pair.valid?).to be_falsey
  end
end
