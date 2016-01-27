module V1
  class RenuoUploadCredentialsController < ApplicationController
    before_action :verify_key_pair

    def index
      service = RenuoUploadCredentialsService.new
      render json: { renuo_upload_credentials: service.credentials(params[:api_key], params[:private_api_key]) }
    end

    def verify_key_pair
      pair_exists = CredentialPair.exists?(private_api_key: params[:private_api_key], api_key: params[:api_key])
      head :unauthorized unless pair_exists
    end
  end
end
