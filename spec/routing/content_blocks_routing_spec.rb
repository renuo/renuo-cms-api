require 'rails_helper'

RSpec.describe 'routes for ContentBlocks', type: :routing do
  let(:api_base_path) { '/api/content_blocks' }

  it 'does not route index requests without api key' do
    expect(post: api_base_path).not_to be_routable
    expect(get: api_base_path).not_to be_routable
    expect(patch: api_base_path).not_to be_routable
    expect(delete: api_base_path).not_to be_routable
  end

  it 'routes the create requests via POST' do
    expect(post: "#{api_base_path}/apikey/sample/path").to be_routable
  end

  it 'routes the get requests via GET' do
    expect(get: "#{api_base_path}/apikey/sample/path").to be_routable
  end

  it 'does not route the update requests via PATCH' do
    expect(patch: "#{api_base_path}/apikey/sample/path").not_to be_routable
  end

  it 'does not route the DELETE requests' do
    expect(delete: "#{api_base_path}/apikey/sample/path").not_to be_routable
  end

  it 'does not route the "wrong" POST request' do
    expect(post: "#{api_base_path}/apikey").not_to be_routable
  end
end
