# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'routes for ContentBlocks', type: :routing do
  let(:api_base_path) { '/v1/sOmE4piK1/content_blocks' }

  let(:basic_expected) do
    { controller: 'v1/content_blocks', api_key: 'sOmE4piK1', format: 'json' }
  end

  it 'routes the create requests via PUT' do
    expected = basic_expected.merge(action: 'store')
    expect(put: api_base_path.to_s).to route_to(expected)
  end

  it 'routes the get requests via GET' do
    expected = basic_expected.merge(action: 'fetch', content_path: 'sample/path')
    expect(get: "#{api_base_path}/sample/path").to route_to(expected)
  end

  it 'routes the batch get requests via GET' do
    expected = basic_expected.merge(action: 'index')
    expect(get: api_base_path.to_s).to route_to(expected)
  end

  it 'does not route the update requests via PATCH' do
    expect(patch: "#{api_base_path}/sample/path").not_to be_routable
  end

  it 'does not route the DELETE requests' do
    expect(delete: "#{api_base_path}/sample/path").not_to be_routable
  end

  it 'does not route the "wrong" PUT request' do
    expect(put: "#{api_base_path}/sample/path").not_to be_routable
  end

  it 'does not route the "wrong" POST request' do
    expect(post: "#{api_base_path}/sample/path").not_to be_routable
  end
end
