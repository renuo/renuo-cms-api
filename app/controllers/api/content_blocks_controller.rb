module Api
  class ContentBlocksController < ApplicationController
    before_action :set_content_block, only: [:show, :update, :destroy]
    before_action :verify_private_api_key, except: [:show]

    respond_to :json

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
      @content_block = ContentBlock.find_by(api_key: api_key_param, content_path: content_path_param)
      head :not_found unless @content_block
    end

    def content_block_params
      # TODO: What to permit here? Are there differences between PATCH and POST?
      params.require(:content_block).permit(:api_key, :content_path, :content)
    end

    def api_key_param
      params.require(:api_key)
    end

    def content_path_param
      params.require(:content_path)
    end

    def private_api_key_param
      params.require(:private_api_key)
    end

    def verify_private_api_key
      private_api_key = CredentialPair.exists?(private_api_key: private_api_key_param)
      head :unauthorized unless private_api_key
    end
  end
end
