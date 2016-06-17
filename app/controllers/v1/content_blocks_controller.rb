module V1
  class ContentBlocksController < ApplicationController
    include VerificationCheck

    before_action :verify_key_pair, only: [:store]
    before_action :initialize_service

    def fetch
      @content_block = @content_blocks_service.find_or_initialize(params[:content_path])
      expires_in 30.seconds, public: true, 's-maxage' => 30.seconds
      render json: @content_block, serializer: V1::ContentBlockSerializer, adapter: :json
    end

    def index
      @content_blocks = @content_blocks_service.all
      expires_in 2.minutes, public: true, 's-maxage' => 2.minutes
      render json: @content_blocks, each_serializer: V1::ContentBlockSerializer, adapter: :json, root: 'content_blocks'
    end

    def store
      content_path = params[:content_block][:content_path]
      @content_block = @content_blocks_service.create_or_update(content_path, content_block_params)

      render json: @content_block, serializer: V1::ContentBlockSerializer, adapter: :json
    end

    private

    def initialize_service
      @content_blocks_service = ContentBlocksService.new(params[:api_key])
    end

    def content_block_params
      params.require(:content_block).permit(:content)
    end
  end
end
