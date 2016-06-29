class ContentBlocksService
  def initialize(api_key)
    @api_key = api_key
  end

  # @return [ContentBlock]
  def find_or_initialize(content_path)
    ContentBlock.find_or_initialize_by api_key: @api_key, content_path: content_path
  end

  # @return [ContentBlock]
  def create_or_update(content_path, content_block_params, predecessor_version = nil)
    content_block = find_or_initialize content_path
    raise OutdatedError if predecessor_version && predecessor_version != content_block.version
    content_block.update! content_block_params
    content_block
  end

  # @return [Array<ContentBlock>]
  def all
    ContentBlock.where(api_key: @api_key).to_a
  end

  # @return [Array]
  def unhashed_etag
    [@api_key, last_modified_at]
  end

  private

  # @return [TimeWithZone]
  def last_modified_at
    ContentBlock.where(api_key: @api_key).maximum(:updated_at)
  end
end
