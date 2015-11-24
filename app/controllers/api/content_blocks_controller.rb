module Api
  class ContentBlocksController < ApplicationController
    before_action :verify_private_api_key, except: [:show]
    before_action :set_content_block

    def show
      render json: @content_block
    end

    def update
      @content_block.update!(content: params[:content_block][:content])
      render json: @content_block
    end

    private

    def set_content_block
      @content_block = ContentBlock.find_or_initialize_by api_key: params[:api_key], content_path: params[:content_path]
    end

    def verify_private_api_key
      private_api_key = CredentialPair.exists?(private_api_key: params[:private_api_key], api_key: params[:api_key])
      head :unauthorized unless private_api_key
    end
  end
end
