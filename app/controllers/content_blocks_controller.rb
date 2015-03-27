class ContentBlocksController < ApplicationController
  before_action :set_content_block, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token

  respond_to :html, :json

  def index
    @content_blocks = ContentBlock.all
  end

  def show
  end

  def new
    @content_block = ContentBlock.new
  end

  def edit
  end

  def create
    @content_block = ContentBlock.new(content_block_params)

    respond_to do |format|
      if @content_block.save
        format.html { redirect_to @content_block, notice: 'Content block was successfully created.' }
        format.json { render json: @content_block, status: :created, location: @content_block }
      else
        format.html { render :new }
        format.json { render json: @content_block.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @content_block.update(content_block_params)
      redirect_to @content_block, notice: 'Content block was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @content_block.destroy
    respond_to do |format|
      format.html { redirect_to content_blocks_url, notice: 'Content block was successfully destroyed.' }
    end
  end

  private

  def set_content_block
    @content_block = ContentBlock.find(params[:id])
  end

  def content_block_params
    params.require(:content_block).permit(:content_path, :content)
  end
end
