# frozen_string_literal: true
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
      if stale?(etag: @content_blocks_service.unhashed_etag, template: false)
        @content_blocks_json = serialized_content_blocks
        render json: @content_blocks_json
        expires_in 2.minutes, public: true, 's-maxage' => 2.minutes
      end
    end

    def store
      block_params = params[:content_block]
      content_path = block_params[:content_path]
      predecessor_version = block_params[:version].try(:to_i)
      return head 409 if @content_blocks_service.outdated?(content_path, predecessor_version)
      @content_block = @content_blocks_service.create_or_update(content_path, content_block_params)
      render json: @content_block, serializer: V1::ContentBlockSerializer, adapter: :json
    end

    private

    def serialized_content_blocks
      Rails.cache.fetch(@content_blocks_service.unhashed_etag, expires_in: 30.days) do
        options = { serializer: V1::ContentBlockSerializer, root: 'content_blocks' }
        serializer = ActiveModel::Serializer::CollectionSerializer.new(@content_blocks_service.all, options)
        ActiveModelSerializers::Adapter::Json.new(serializer).to_json
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
