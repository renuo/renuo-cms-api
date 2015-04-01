module Api
  class ContentBlocksController < ApplicationController
    before_action :set_content_block, only: [:show, :update, :destroy]
    skip_before_filter :verify_authenticity_token
    # API KEY NOT IN USE YET, UNTESTED
    # before_filter :restrict_access

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

    # def restrict_access
    #   authenticate_or_request_with_http_token do |token, options|
    #     ApiKey.exists?(access_token: token)
    #   end
    # end
  end
end
