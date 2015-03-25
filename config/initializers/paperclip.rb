Paperclip::Attachment.default_options.merge!(
  storage: :s3,
  s3_credentials: {
    bucket: ENV['S3_BUCKET_NAME'],
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  },
  path: '/:class/:attachment/:id_partition/:style/:filename',
  s3_host_name: 's3-eu-central-1.amazonaws.com',
  url: ':s3_eu_url'
)

Paperclip.interpolates(:s3_eu_url) do |att, style|
  "#{att.s3_protocol}://s3-eu-central-1.amazonaws.com/#{att.bucket_name}/#{att.path(style).gsub(%r{^/}, '')}"
end
