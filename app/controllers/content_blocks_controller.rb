class ContentBlocksController < ApplicationController
  before_action :set_content_block, only: [:show, :edit, :update, :destroy]

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
    if @content_block.save
      redirect_to @content_block, notice: 'Content block was successfully created.'
    else
      render :new
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
    redirect_to content_blocks_url, notice: 'Content block was successfully destroyed.'
  end

  private

  def set_content_block
    @content_block = ContentBlock.find(params[:id])
  end

  def content_block_params
    params.require(:content_block).permit(:content_path, :content)
  end
end
