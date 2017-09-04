# frozen_string_literal: true
class ContentBlocksService
  def initialize(api_key)
    @api_key = api_key
  end

  # @return [ContentBlock]
  def find_or_initialize(content_path)
    ContentBlock.find_or_initialize_by api_key: @api_key, content_path: content_path
  end

  def outdated?(content_path, version = nil)
    return false if version.nil?
    content_block = find_or_initialize content_path
    version != content_block.version
  end

  # @return [ContentBlock]
  def create_or_update(content_path, content_block_params)
    content_block = find_or_initialize content_path
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
