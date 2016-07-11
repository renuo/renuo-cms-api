# frozen_string_literal: true
module V1
  module VerificationCheck
    def verify_key_pair
      pair_exists = CredentialPair.exists?(private_api_key: params[:private_api_key], api_key: params[:api_key])
      head :unauthorized unless pair_exists
    end
  end
end
