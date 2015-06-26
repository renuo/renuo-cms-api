require 'rails_helper'

RSpec.describe Api::ContentBlocksController, type: :controller do
  render_views

  let!(:content_block) { create(:content_block) }
  let(:credential_pair) { create(:credential_pair, api_key: content_block.api_key) }
  let(:default_api_params) do
    {
      format: :json,
      api_key: content_block.api_key,
      content_path: content_block.content_path
    }
  end
  let(:elevated_api_params) do
    default_api_params.merge(private_api_key: credential_pair.private_api_key)
  end

  let(:json) { JSON.parse(response.body) }

  before(:each) do
    allow(ContentBlock).to receive(:find_by).and_return(content_block)
  end

  context 'requesting a content block' do
    describe 'GET /api/content_blocks/:api_key/:content_path' do
      it 'checks whether the right JSON responds to a GET request to a show action' do
        get :show, default_api_params
        expect(assigns(:content_block)).to be(content_block)
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(content_block.to_json)
      end
    end
  end

  context 'changing a content block' do
    describe 'POST /api/content_blocks/:api_key' do
      it 'checks wether a record gets created when posting JSON' do
        content_block_attributes = attributes_for(:content_block)
        expect do
          post :create, elevated_api_params.merge(content_block: content_block_attributes)
        end.to change { ContentBlock.count }.by(1)
        expect(response).to have_http_status(:created)
      end
    end

    describe 'PUT /api/content_blocks/:api_key/:content_path' do
      it 'checks wether a record gets created when posting JSON' do
        new_content_block = {
          api_key: content_block.api_key,
          content: 'foo baz'
        }
        put :update, elevated_api_params.merge(content_block: new_content_block)
        expect(response).to have_http_status(:ok)
        expect(assigns(:content_block)).to be(content_block)
        expect(ContentBlock.first.content).to eq(new_content_block[:content])
      end
    end

    describe 'DELETE /api/content_blocks/:api_key/:content_path' do
      it 'checks whether a record can be deleted' do
        delete :destroy, elevated_api_params
        expect(response).to have_http_status(:ok)
        expect(assigns(:content_block)).to be(content_block)
        expect(ContentBlock.count).to be 0
      end
    end
  end

  # TODO: write shared examples
  # to be able to test the api behaviour regarding the presence of a private api key
end
