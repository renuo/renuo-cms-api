# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'ContentBlocks', type: :request do
  let!(:content_block) { create(:content_block) }
  let!(:credential_pair) { create(:credential_pair, api_key: content_block.api_key) }

  def compare_content_blocks(object, content_block)
    expect(object.content_path).to eq(content_block.content_path)
    expect(object.content).to eq(content_block.content)
    expect(object.api_key).to eq(content_block.api_key)
    expect(object.created_at).to eq(content_block.created_at.as_json)
    expect(object.updated_at).to eq(content_block.updated_at.as_json)
    expect(object.id).to be_nil
  end

  context '#index' do
    before(:each) { Rails.cache.clear }

    it 'fetches multiple content blocks' do
      get "/v1/#{credential_pair.api_key}/content_blocks"
      expect(response.headers['Cache-Control']).to eq("max-age=#{2.minutes}, public, s-maxage=#{2.minutes}")
      expect(response).to have_http_status(200)
      blocks = JSON.parse(response.body)['content_blocks']
      expect(blocks.size).to eq(1)
      object = OpenStruct.new(blocks[0])
      compare_content_blocks(object, content_block)
    end

    it 'fetches empty content blocks array if no content blocks are in the database' do
      empty_credential_pair = create(:credential_pair, :empty)
      get "/v1/#{empty_credential_pair.api_key}/content_blocks"
      expect(response.headers['Cache-Control']).to eq("max-age=#{2.minutes}, public, s-maxage=#{2.minutes}")
      expect(response).to have_http_status(200)
      response_json = JSON.parse(response.body)
      expect(response_json).to have_key('content_blocks')
      expect(response_json['content_blocks']).to eq([])
    end
  end

  context '#fetch' do
    it 'fetches a content block' do
      get "/v1/#{credential_pair.api_key}/content_blocks/#{content_block.content_path}"
      expect(response.headers['Cache-Control']).to eq('max-age=30, public, s-maxage=30')
      expect(response).to have_http_status(200)
      object = OpenStruct.new(JSON.parse(response.body)['content_block'])
      compare_content_blocks(object, content_block)
    end
  end

  context '#store' do
    it 'updates a content block' do
      put "/v1/#{credential_pair.api_key}/content_blocks",
          private_api_key: credential_pair.private_api_key,
          content_block: {
            content: 'new content',
            content_path: content_block.content_path,
            api_key: credential_pair.api_key
          }
      expect(response).to have_http_status(200)
      object = OpenStruct.new(JSON.parse(response.body)['content_block'])
      expect(object.content_path).to eq(content_block.content_path)
      expect(object.content).to eq('new content')
      expect(object.api_key).to eq(content_block.api_key)
      expect(object.created_at).to eq(content_block.created_at.as_json)
      expect(object.updated_at).to be_between(5.seconds.ago, 0.seconds.ago)
      expect(object.id).to be_nil
      expect(ContentBlock.last.content).to eq('new content')
    end

    it 'creates a content block' do
      put "/v1/#{credential_pair.api_key}/content_blocks",
          private_api_key: credential_pair.private_api_key,
          content_block: {
            content: 'bla content',
            content_path: 'blub-path',
            api_key: credential_pair.api_key
          }
      expect(response).to have_http_status(200)
      object = OpenStruct.new(JSON.parse(response.body)['content_block'])
      expect(object.content_path).to eq('blub-path')
      expect(object.content).to eq('bla content')
      expect(object.api_key).to eq(content_block.api_key)
      expect(object.created_at).to be_between(5.seconds.ago, 0.seconds.ago)
      expect(object.updated_at).to be_between(5.seconds.ago, 0.seconds.ago)
      expect(object.id).to be_nil
      expect(ContentBlock.last.content).to eq('bla content')
    end
  end
end
