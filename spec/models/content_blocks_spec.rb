# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ContentBlock, type: :model do
  it 'reads a content_blocks content' do
    content_block = build(:content_block)
    expect(content_block.content).to start_with('<h1>')
    expect(content_block.content_path).to start_with('path-')
    expect(content_block.api_key).to be_truthy
  end

  it 'checks whether a content_blocks content can be edited' do
    content_block = create(:content_block)
    expect(content_block.content).to_not eq('foo bar')
    content_block.update_attribute(:content, 'foo bar')
    expect(content_block.content).to eq('foo bar')
  end

  it 'checks whether a content_block can be deleted' do
    create(:content_block)
    expect(ContentBlock.count).to eq(1)
    ContentBlock.first.destroy
    expect(ContentBlock.count).to eq(0)
  end

  it 'creates multiple content_blocks' do
    expect(ContentBlock.count).to eq(0)
    5.times { create(:content_block) }
    expect(ContentBlock.count).to eq(5)
  end

  it 'implements PaperTrail' do
    expect(ContentBlock.paper_trail.enabled?).to be true
  end

  describe '#version' do
    it 'prints the current version of the content block' do
      block = create(:content_block, content: 'version 1')
      expect(block.version).to eq 1

      block.update(content: 'version 2')
      expect(block.version).to eq 2

      block.update(content: 'version 3')
      expect(block.version).to eq 3
    end

    it 'returns 0, if there are no paper trail versions of the block yet' do
      ContentBlock.paper_trail.disable
      block = create(:content_block, content: 'version created before Paper Trail was enabled')
      ContentBlock.paper_trail.enable
      expect(block.version).to eq 0

      block.update(content: 'version 1 (now with paper trail)')
      expect(block.version).to eq 1

      block.update(content: 'version 2')
      expect(block.version).to eq 2
    end
  end
end
