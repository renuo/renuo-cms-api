require 'rails_helper'

RSpec.describe 'Home', type: :request do
  context 'initial test' do
    it 'should check if the app is ok and connected to a database' do
      get '/home/check'
      expect(response).to have_http_status(200)
      expect(response.body).to eq('1+2=3')
    end
  end
end
