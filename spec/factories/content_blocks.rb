FactoryGirl.define do
  factory :content_block do
    sequence(:content_path) { |i| "path-#{i}" }
    content "<h1>#{Faker::Lorem.word}</h1><p>#{Faker::Lorem.paragraph}<br/>#{Faker::Lorem.paragraph}</p>"
    api_key Kernel.rand(1_000_000_000..2_000_000_000).to_s(16)

    factory :content_block_with_credentials do
      after(:create) { |cb, _e| create(:credential_pair, api_key: cb.api_key) }
    end
  end
end
