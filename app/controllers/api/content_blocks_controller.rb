module Api
  class ContentBlocksController < ApplicationController
    before_action :set_content_block, only: [:show, :update, :destroy]
    skip_before_action :verify_authenticity_token

    respond_to :json

    def index
      respond_with ContentBlock.all
    end

    def show
      respond_with @content_block
    end

    def create
      render json: ContentBlock.create(content_block_params)
    end

    def update
      render json: @content_block.update(content_block_params)
    end

    def destroy
      render json: @content_block.destroy
    end

    private

    def set_content_block
      @content_block = ContentBlock.find(params[:id])
    end

    def content_block_params
      params.require(:content_block).permit(:content_path, :content)
    end
  end
end
