# frozen_string_literal: true
class RenuoUploadCredentialsService
  def credentials(api_key, private_api_key)
    pair = CredentialPair.find_by! api_key: api_key, private_api_key: private_api_key
    { api_key: pair.renuo_upload_api_key, signing_url: pair.renuo_upload_signing_url }
  end
end
