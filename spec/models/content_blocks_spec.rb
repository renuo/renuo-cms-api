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
end
