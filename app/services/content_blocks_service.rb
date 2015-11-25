class ContentBlocksService
  def initialize(api_key)
    @api_key = api_key
  end

  # @return [ContentBlock]
  def find_or_initialize(content_path)
    ContentBlock.find_or_initialize_by api_key: @api_key, content_path: content_path
  end

  # @return [ContentBlock]
  def create_or_update(content_path, content_block_params)
    content_block = find_or_initialize content_path
    content_block.update! content_block_params
    content_block
  end
end
