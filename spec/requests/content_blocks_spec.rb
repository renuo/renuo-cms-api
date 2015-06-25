require 'rails_helper'

RSpec.describe Api::ContentBlocksController, type: :controller do
  render_views
  let(:json) { JSON.parse(response.body) }
  let(:content_block) { create(:content_block) }

  describe 'GET /api/content_blocks/:id' do
    it 'checks whether the right JSON responds to a GET request to a show action' do
      get :show, format: :json, id: content_block.id, content_block: {api_key: content_block.api_key}
      expect(response.body).to eq(content_block.to_json)
    end
  end

  describe 'POST /api/content_blocks' do
    it 'checks wether a record gets created when posting JSON' do
      content_block = attributes_for(:content_block)
      expect do
        post :create, format: :json, content_block: content_block
      end.to change { ContentBlock.count }.by(1)
    end
  end

  describe 'PUT /api/content_blocks/:id' do
    it 'checks wether a record gets created when posting JSON' do
      new_content_block = {
        api_key: content_block.api_key,
        content: 'foo baz'
      }
      post :update, format: :json, id: content_block.id, content_block: new_content_block
      expect(ContentBlock.first.content).to eq(new_content_block[:content])
    end
  end

  describe 'DELETE /api/content_blocks/:id' do
    it 'checks whether a record can be deleted' do
      delete :destroy, format: :json, api_key: '1', id: content_block.id, content_block: {api_key: content_block.api_key}
      expect(ContentBlock.count).to be 0
    end
  end
end
