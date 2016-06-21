module V1
  class ContentBlocksController < ApplicationController
    include VerificationCheck

    before_action :verify_key_pair, only: [:store]
    before_action :initialize_service

    def fetch
      @content_block = @content_blocks_service.find_or_initialize(params[:content_path])
      if stale?(@content_block)
        expires_in 30.seconds, public: true, 's-maxage' => 30.seconds
        render json: @content_block
      end
    end

    def index
      if stale?(etag: @content_blocks_service.unhashed_etag, last_modified: @content_blocks_service.last_modified_at)
        @content_blocks_json = serialized_content_blocks
        expires_in 2.minutes, public: true, 's-maxage' => 2.minutes
        render json: @content_blocks_json
      end
    end

    def store
      content_path = params[:content_block][:content_path]
      @content_block = @content_blocks_service.create_or_update(content_path, content_block_params)
      render json: @content_block
    end

    private

    def serialized_content_blocks
      Rails.cache.fetch(@content_blocks_service.unhashed_etag, expires_in: 12.hours) do
        ActiveModel::ArraySerializer.new(@content_blocks_service.all, each_serializer: ContentBlockSerializer,
                                                                      root: 'content_blocks').as_json
      end
    end

    def initialize_service
      @content_blocks_service = ContentBlocksService.new(params[:api_key])
    end

    def content_block_params
      params.require(:content_block).permit(:content)
    end
  end
end
