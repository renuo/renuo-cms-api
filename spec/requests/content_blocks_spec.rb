require 'rails_helper'

RSpec.describe Api::ContentBlocksController, type: :controller do
  render_views

  let!(:content_block) { create(:content_block) }
  let!(:default_api_params) do
    {
      format: :json,
      api_key: content_block.api_key,
      content_path: content_block.content_path
    }
  end

  let(:json) { JSON.parse(response.body) }

  describe 'GET /api/content_blocks/:api_key/:content_path' do
    it 'checks whether the right JSON responds to a GET request to a show action' do
      get :show, default_api_params
      expect(response.body).to eq(content_block.to_json)
    end
  end

  describe 'POST /api/content_blocks/:api_key' do
    it 'checks wether a record gets created when posting JSON' do
      content_block_attributes = attributes_for(:content_block)
      expect do
        post :create, default_api_params.merge(content_block: content_block_attributes)
      end.to change { ContentBlock.count }.by(1)
    end
  end

  describe 'PUT /api/content_blocks/:api_key/:content_path' do
    it 'checks wether a record gets created when posting JSON' do
      new_content_block = {
        api_key: content_block.api_key,
        content: 'foo baz'
      }
      post :update, default_api_params.merge(content_block: new_content_block)
      expect(ContentBlock.first.content).to eq(new_content_block[:content])
    end
  end

  describe 'DELETE /api/content_blocks/:api_key/:content_path' do
    it 'checks whether a record can be deleted' do
      delete :destroy, default_api_params
      expect(ContentBlock.count).to be 0
    end
  end
end
