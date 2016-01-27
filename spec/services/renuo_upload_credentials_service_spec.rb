require 'rails_helper'

RSpec.describe RenuoUploadCredentialsService do
  describe '#credentials' do
    it 'returns the credentials for an existing api_key and private_api_key' do
      pair = create(:credential_pair)
      service = RenuoUploadCredentialsService.new
      expected = { api_key: pair.renuo_upload_api_key, signing_url: pair.renuo_upload_signing_url }
      expect(service.credentials(pair.api_key, pair.private_api_key)).to eq(expected)
    end
  end
end
