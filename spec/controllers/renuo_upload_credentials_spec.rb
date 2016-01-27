require 'rails_helper'

RSpec.describe V1::RenuoUploadCredentialsController, type: :controller do
  context 'get renuo upload credentials' do
    let!(:pair) {}

    describe 'GET index' do
      it 'gets the credentials' do
        credential_pair = create(:credential_pair)
        get :index, api_key: credential_pair.api_key, private_api_key: credential_pair.private_api_key
        expect(response).to have_http_status(:ok)
        object = OpenStruct.new(JSON.parse(response.body)['renuo_upload_credentials'])
        expect(object.api_key).to eq(credential_pair.renuo_upload_api_key)
        expect(object.signing_url).to eq(credential_pair.renuo_upload_signing_url)
      end
    end
  end
end
