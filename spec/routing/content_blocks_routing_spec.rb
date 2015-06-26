require 'rails_helper'

RSpec.describe 'routes for ContentBlocks', type: :routing do
  it 'routes /content_blocks not to the content_blocks controller' do
    expect(get: '/api/content_blocks').not_to be_routable
  end

  it 'routes the typical requests' do
    expect(post: '/api/content_blocks/apikey').to be_routable
    expect(get: '/api/content_blocks/apikey/sample/path').to be_routable
    expect(put: '/api/content_blocks/apikey/sample/path').to be_routable
    expect(delete: '/api/content_blocks/apikey/sample/path').to be_routable
  end
end
