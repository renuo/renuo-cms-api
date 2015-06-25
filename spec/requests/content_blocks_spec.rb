require 'rails_helper'

RSpec.describe Api::ContentBlocksController, type: :controller do
  render_views
  let(:json) { JSON.parse(response.body) }
  let(:content_block) { create(:content_block) }

  describe 'GET /api/content_blocks/:id' do
    it 'checks whether the right JSON responds to a GET request to a show action' do
      get :show, format: :json, id: content_block.id
      expect(response.body).to eq(content_block.to_json)
    end
  end

  describe 'POST /api/content_blocks' do
    it 'checks wether a record gets created when posting JSON' do
      content_block = build(:content_block)
      expect do
        post :create, format: :json,
                      content_block: {
                        content_path: content_block.content_path,
                        content: content_block.content
                      }
      end.to change { ContentBlock.count }.by(1)
    end
  end

  describe 'PUT /api/content_blocks/:id' do
    it 'checks wether a record gets created when posting JSON' do
      new_content = 'foo baz'
      post :update, format: :json, id: content_block.id, content_block: { content: new_content }
      expect(ContentBlock.first.content).to eq(new_content)
    end
  end

  describe 'DELETE /api/content_blocks/:id' do
    it 'checks whether a record can be deleted' do
      delete :destroy, format: :json, id: content_block.id
      expect(ContentBlock.count).to be 0
    end
  end
end
