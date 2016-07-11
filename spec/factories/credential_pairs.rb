# frozen_string_literal: true
FactoryGirl.define do
  factory :credential_pair do
    private_api_key Kernel.rand(1_000_000_000..2_000_000_000).to_s(16)
    api_key Kernel.rand(1_000_000_000..2_000_000_000).to_s(16)
    project_name "project-#{Kernel.rand(1_000_000_000..2_000_000_000).to_s(16)}"
    renuo_upload_api_key '87VJCHauQZuTyY92JOjy0c6tW'
    renuo_upload_signing_url 'https://some.host'

    trait :empty do
      private_api_key Kernel.rand(1_000_000_000..2_000_000_000).to_s(16)
      api_key Kernel.rand(1_000_000_000..2_000_000_000).to_s(16)
      project_name "project-#{Kernel.rand(1_000_000_000..2_000_000_000).to_s(16)}"
    end
  end
end
