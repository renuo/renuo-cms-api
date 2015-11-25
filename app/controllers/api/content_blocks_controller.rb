module Api
  class ContentBlocksController < ApplicationController
    before_action :verify_private_api_key, except: [:show]

    def show
      @content_block = ContentBlock.find_or_initialize_by api_key: params[:api_key], content_path: params[:content_path]
      render json: @content_block
    end

    def update
      content_path = params[:content_block][:content_path]
      api_key = params[:api_key]

      @content_block = ContentBlock.find_or_initialize_by(api_key: api_key, content_path: content_path)
      @content_block.update!(content_block_params)

      render json: @content_block
    end

    private

    def content_block_params
      params.require(:content_block).permit(:content)
    end

    def verify_private_api_key
      private_api_key = CredentialPair.exists?(private_api_key: params[:private_api_key], api_key: params[:api_key])
      head :unauthorized unless private_api_key
    end
  end
end
