module Api
  class ContentBlocksController < ApplicationController
    before_action :set_content_block, only: [:show, :update, :destroy]
    skip_before_action :verify_authenticity_token

    respond_to :json

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
      unless params[:content_block][:api_key].present?
        raise(ActionController::ParameterMissing.new(:api_key))
      end
      params.require(:content_block).permit(:api_key, :content_path, :content)
    end
  end
end
