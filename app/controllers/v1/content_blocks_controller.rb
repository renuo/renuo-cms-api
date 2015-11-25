module V1
  class ContentBlocksController < ApplicationController
    before_action :verify_key_pair, except: [:fetch]
    before_action :initialize_service

    def fetch
      @content_block = @content_blocks_service.find_or_initialize(params[:content_path])
      render json: @content_block, serializer: V1::ContentBlockSerializer
    end

    def store
      content_path = params[:content_block][:content_path]
      @content_block = @content_blocks_service.create_or_update(content_path, content_block_params)

      render json: @content_block, serializer: ContentBlockSerializer
    end

    private

    def initialize_service
      @content_blocks_service = ContentBlocksService.new(params[:api_key])
    end

    def content_block_params
      params.require(:content_block).permit(:content)
    end

    def verify_key_pair
      pair_exists = CredentialPair.exists?(private_api_key: params[:private_api_key], api_key: params[:api_key])
      head :unauthorized unless pair_exists
    end
  end
end
