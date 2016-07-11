# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'routes for RenuoUploadCredentials', type: :routing do
  it 'routes to renuo upload credentials' do
    expected = { controller: 'v1/renuo_upload_credentials', api_key: 'sOmE4piK1', private_api_key: 'pRk4aL',
                 format: 'json', action: 'index' }
    expect(get: '/v1/sOmE4piK1/renuo_upload_credentials?private_api_key=pRk4aL').to route_to(expected)
  end
end
