require 'rails_helper'

RSpec.describe 'ContentBlocks', type: :request do
  let!(:content_block) { create(:content_block) }
  let!(:credential_pair) { create(:credential_pair, api_key: content_block.api_key) }

  context '#fetch' do
    it 'fetches a content block' do

      get "/v1/#{credential_pair.api_key}/content_blocks/#{content_block.content_path}"
      expect(response).to have_http_status(200)
      object = OpenStruct.new(JSON.parse(response.body))
      expect(object.content_path).to eq(content_block.content_path)
      expect(object.content).to eq(content_block.content)
      expect(object.api_key).to eq(content_block.api_key)
      expect(object.created_at).to eq(content_block.created_at.as_json)
      expect(object.updated_at).to eq(content_block.updated_at.as_json)
    end
  end
end
