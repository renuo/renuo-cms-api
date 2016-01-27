module V1
  class RenuoUploadCredentialsController < ApplicationController
    include VerificationCheck

    before_action :verify_key_pair

    def index
      service = RenuoUploadCredentialsService.new
      render json: { renuo_upload_credentials: service.credentials(params[:api_key], params[:private_api_key]) }
    end
  end
end
