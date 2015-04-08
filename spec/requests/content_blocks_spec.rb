require 'rails_helper'

def create_content_blocks
  2.times do |number|
    create(:content_block, content_path: "path/#{number}")
  end
end

RSpec.describe Api::ContentBlocksController, type: :controller do
  render_views
  let(:json) { JSON.parse(response.body) }

  describe 'GET /api/content_blocks' do
    it 'checks whether the right JSON responds to a GET request to the index action' do
      create_content_blocks
      get :index, format: :json
      expect(response.body).to eq(ContentBlock.all.to_json)
    end
  end

  describe 'GET /api/content_blocks/:id' do
    it 'checks whether the right JSON responds to a GET request to a show action' do
      create_content_blocks
      get :show, format: :json, id: 1
      expect(response.body).to eq(ContentBlock.first.to_json)
    end
  end

  describe 'POST /api/content_blocks' do
    it 'checks wether a record gets created when posting JSON' do
      post :create, format: :json, content_block: { content_path: 'foo/bar', content: Faker::Lorem.paragraph }
      expect(ContentBlock.count).to eq(1)
      expect(ContentBlock.last.content_path).to eq('foo/bar')
    end
  end

  describe 'PUT /api/content_blocks/:id' do
    it 'checks wether a record gets created when posting JSON' do
      create_content_blocks
      old_content = ContentBlock.first.content
      post :update, format: :json, id: 1, content_block: { content: 'foo bar' }
      expect(ContentBlock.find(1).content).to_not eq(old_content)
      expect(ContentBlock.find(1).content).to eq('foo bar')
    end
  end

  describe 'DELETE /api/content_blocks/:id' do
    it 'checks whether a record can be deleted' do
      create_content_blocks
      delete :destroy, format: :json, id: 1
      expect(ContentBlock.count).to eq(1)
      expect(ContentBlock.where(id: 1).empty?).to be_truthy
    end
  end
end
