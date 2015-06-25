require 'rails_helper'

RSpec.describe 'routes for ContentBlocks', type: :routing do
  it 'routes /content_blocks not to the content_blocks controller' do
    expect(get: '/content_blocks').not_to be_routable
  end
end


