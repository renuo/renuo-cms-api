module V1
  class ContentBlockSerializer < ActiveModel::Serializer
    attributes :content, :content_path, :api_key, :updated_at, :created_at, :version
  end
end
