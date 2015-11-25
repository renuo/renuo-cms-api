require 'rails_helper'

RSpec.describe ContentBlocksService do
  describe '#find_or_initialize' do
    it 'finds initializes a new content block' do
      content_block = ContentBlocksService.new('x3vs').find_or_initialize('my-path')
      expect(content_block.new_record?).to be_truthy
      expect(content_block.content).to eq('')
      expect(content_block.content_path).to eq('my-path')
      expect(content_block.api_key).to eq('x3vs')
    end

    it 'checks whether a content_blocks content can be edited' do
      existing = create(:content_block)
      content_block = ContentBlocksService.new(existing.api_key).find_or_initialize(existing.content_path)
      expect(content_block.new_record?).to be_falsey
      expect(content_block.content).to eq(existing.content)
      expect(content_block.content_path).to eq(existing.content_path)
      expect(content_block.api_key).to eq(existing.api_key)
    end

    it 'returns a new content block when the api key does not exist' do
      existing = create(:content_block)
      content_block = ContentBlocksService.new('x3vs').find_or_initialize(existing.content_path)
      expect(content_block.new_record?).to be_truthy
      expect(content_block.content).to eq('')
      expect(content_block.content_path).to eq(existing.content_path)
      expect(content_block.api_key).to eq('x3vs')
    end

    it 'returns a new content block when the content path does not exist' do
      existing = create(:content_block)
      content_block = ContentBlocksService.new(existing.api_key).find_or_initialize('new-path')
      expect(content_block.new_record?).to be_truthy
      expect(content_block.content).to eq('')
      expect(content_block.content_path).to eq('new-path')
      expect(content_block.api_key).to eq(existing.api_key)
    end
  end

  describe '#create_or_update' do
    it 'creates a new content block' do
      expect do
        content_block = ContentBlocksService.new('x3vs').create_or_update('my-path', content: 'new content')
        expect(content_block.content_path).to eq('my-path')
        expect(content_block.content).to eq('new content')
        expect(content_block.api_key).to eq('x3vs')
      end.to change { ContentBlock.count }.by(1)
    end

    it 'updates the content of an existing content block' do
      existing = create(:content_block)
      expect(existing.content).not_to eq('Z')
      expect do
        content_block = ContentBlocksService.new(existing.api_key).create_or_update(existing.content_path, content: 'Z')
        expect(content_block.api_key).to eq(existing.api_key)
        expect(content_block.content_path).to eq(existing.content_path)
        expect(content_block.content).to eq('Z')
      end.not_to change { ContentBlock.count }
    end
  end
end
