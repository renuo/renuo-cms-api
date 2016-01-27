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

      it 'blocks when the private api key is non-existent' do
        credential_pair = create(:credential_pair)
        unauthorized_api_params = { api_key: credential_pair.api_key, private_api_key: 'non-existent-private-api-key' }
        get :index, unauthorized_api_params
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq('')
      end

      it 'does not find a resource' do
        invalid_authorized_api_params = { api_key: 'non-exist', private_api_key: 'whatever' }
        get :index, invalid_authorized_api_params
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq('')
      end
    end
  end
end
