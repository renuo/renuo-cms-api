require 'rails_helper'

RSpec.describe 'routes for ContentBlocks', type: :routing do
  let(:api_base_path) { '/api/content_blocks' }

  it 'doesnt route index requests without api key' do
    expect(post: api_base_path).not_to be_routable
    expect(get: api_base_path).not_to be_routable
    expect(patch: api_base_path).not_to be_routable
    expect(delete: api_base_path).not_to be_routable
  end

  it 'routes the typical requests' do
    expect(post: "#{api_base_path}/apikey").to be_routable
    expect(get: "#{api_base_path}/apikey/sample/path").to be_routable
    expect(patch: "#{api_base_path}/apikey/sample/path").to be_routable
    expect(delete: "#{api_base_path}/apikey/sample/path").to be_routable
  end
end
