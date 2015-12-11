require 'rails_helper'

RSpec.describe 'routes for ContentBlocks', type: :routing do
  let(:api_base_path) { '/v1/sOmE4piK1/content_blocks' }

  let(:basic_expected) do
    { controller: 'v1/content_blocks', api_key: 'sOmE4piK1', format: 'json' }
  end

  it 'routes the create requests via POST' do
    expected = basic_expected.merge(action: 'store')
    expect(post: "#{api_base_path}").to route_to(expected)
  end

  it 'routes the get requests via GET' do
    expected = basic_expected.merge(action: 'fetch', content_path: 'sample/path')
    expect(get: "#{api_base_path}/sample/path").to route_to(expected)
  end

  it 'routes the batch get requests via GET' do
    expected = basic_expected.merge(action: 'batch_fetch')
    expect(get: "#{api_base_path}").to route_to(expected)
  end

  it 'does not route the update requests via PATCH' do
    expect(patch: "#{api_base_path}/sample/path").not_to be_routable
  end

  it 'does not route the DELETE requests' do
    expect(delete: "#{api_base_path}/sample/path").not_to be_routable
  end

  it 'does not route the "wrong" POST request' do
    expect(post: "#{api_base_path}/sample/path").not_to be_routable
  end
end
