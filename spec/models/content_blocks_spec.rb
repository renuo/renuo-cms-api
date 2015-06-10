require 'rails_helper'

RSpec.describe ContentBlock, type: :model do
  let(:content_block) { create(:content_block) }

  it 'reads a content_blocks content' do
    expect(content_block.content).to_not be_falsey
  end
end
