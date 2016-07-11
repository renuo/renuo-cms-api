# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'RenuoUploadCredentials', type: :request do
  let!(:credential_pair) { create(:credential_pair) }

  context '#index' do
    it 'fetches the renuo upload credentials' do
      get "/v1/#{credential_pair.api_key}/renuo_upload_credentials?private_api_key=#{credential_pair.private_api_key}"
      expect(response).to have_http_status(200)
      object = OpenStruct.new(JSON.parse(response.body)['renuo_upload_credentials'])
      expect(object.api_key).to eq(credential_pair.renuo_upload_api_key)
      expect(object.signing_url).to eq(credential_pair.renuo_upload_signing_url)
    end
  end
end
