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
      @content_block = ContentBlock.find_by(api_key: api_key_param, id: params[:id])
    end

    def content_block_params
      unless api_key_param.present?
        raise(ActionController::ParameterMissing.new(:api_key))
      end
      params.require(:content_block).permit(:api_key, :content_path, :content)
    end

    def api_key_param
      params[:content_block][:api_key]
    end
  end
end
