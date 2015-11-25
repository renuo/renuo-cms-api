require 'rails_helper'

RSpec.describe V1::ContentBlocksController, type: :controller do
  render_views

  let!(:content_block) { create(:content_block) }

  context 'requesting a content block' do
    describe 'GET fetch' do
      it 'checks whether the right JSON responds to a GET request to a show action' do
        get :fetch, api_key: content_block.api_key, content_path: content_block.content_path
        expect(assigns(:content_block)).to eq(content_block)
        expect(assigns(:content_block).created_at).to eq(content_block.created_at)
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(content_block.to_json)
      end

      it 'renders return an empty content without corresponding resource' do
        get :fetch, api_key: 'non-existing-api-key', content_path: 'non-existing-content-path'
        content_block = assigns(:content_block)
        expect(content_block.created_at).to be_nil
        expect(content_block.content).to eq('')
        expect(content_block.api_key).to eq('non-existing-api-key')
        expect(content_block.content_path).to eq('non-existing-content-path')
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'changing a content block' do
    let!(:credential_pair) { create(:credential_pair, api_key: content_block.api_key) }
    let(:authorized_api_params) { { api_key: content_block.api_key, private_api_key: credential_pair.private_api_key } }

    describe 'POST store' do
      it 'creates a new block content' do
        expect do
          new_params = { content_block: { content: 'new content!', content_path: 'some-content-path' } }
          post :store, authorized_api_params.merge(new_params)
        end.to change { ContentBlock.count }.by(1)

        expect(ContentBlock.last.content).to eq('new content!')
        expect(ContentBlock.last.content_path).to eq('some-content-path')
        expect(response).to have_http_status(:ok)
      end

      it 'stores the content of an existing content block' do
        new_content_block = {
          content_path: content_block.content_path,
          api_key: content_block.api_key,
          content: 'some-new-content'
        }
        expect do
          post :store, authorized_api_params.merge(content_block: new_content_block)
        end.not_to change { ContentBlock.count }

        expect(response).to have_http_status(:ok)
        expect(assigns(:content_block)).to eq(content_block)
        expect(ContentBlock.first.content).to eq(new_content_block[:content])
      end

      it 'blocks when the private api key is non-existent' do
        unauthorized_api_params = { api_key: content_block.api_key, private_api_key: 'non-existent-private-api-key' }
        post :store, unauthorized_api_params
        expect(assigns(:content_block)).to be_nil
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not find a resource' do
        invalid_authorized_api_params = { api_key: 'non-exist', private_api_key: credential_pair.private_api_key }
        post :store, invalid_authorized_api_params
        expect(assigns(:content_block)).to be_nil
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
