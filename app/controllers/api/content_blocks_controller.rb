module Api
  class ContentBlocksController < ApplicationController
    before_action :set_content_block, only: [:show, :update, :destroy]
    before_action :verify_private_api_key, except: [:show]

    def show
      render json: @content_block
    end

    def create
      render json: ContentBlock.create(content_block_params), status: :created
    end

    def update
      render json: @content_block.update(content_block_params)
    end

    def destroy
      render json: @content_block.destroy
    end

    private

    def set_content_block
      @content_block = ContentBlock.find_by(api_key: params[:api_key], content_path: params[:content_path])
      head :not_found unless @content_block
    end

    def content_block_params
      params.require(:content_block).permit(:api_key, :content_path, :content)
    end

    def verify_private_api_key
      private_api_key = CredentialPair.exists?(private_api_key: params.require(:private_api_key))
      head :unauthorized unless private_api_key
    end
  end
end
