FactoryGirl.define do
  factory :credential_pair do
    private_api_key Kernel.rand(1_000_000_000..2_000_000_000).to_s(16)
    api_key Kernel.rand(1_000_000_000..2_000_000_000).to_s(16)
  end
end
