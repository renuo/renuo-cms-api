class ContentBlocksService
  def find_or_initialize(api_key, content_path)
    ContentBlock.find_or_initialize_by api_key: api_key, content_path: content_path
  end

  def create_or_update(api_key, content_path, content_block_params)
    content_block = ContentBlock.find_or_initialize_by(api_key: api_key, content_path: content_path)
    content_block.update!(content_block_params)
    content_block
  end
end
