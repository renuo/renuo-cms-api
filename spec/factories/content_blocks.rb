FactoryGirl.define do
  factory :content_block do
    sequence(:content_path) { |i| "path-#{i}" }
    content "<h1>#{Faker::Lorem.word}</h1><p>#{Faker::Lorem.paragraph}<br/>#{Faker::Lorem.paragraph}</p>"
    api_key Kernel.rand(1_000_000_000..2_000_000_000).to_s(16)

    trait :updated_last_week do
      updated_at '2016-06-14'
    end

    trait :updated_yesterday do
      updated_at '2016-06-21'
    end

    trait :updated_today do
      updated_at '2016-06-20'
    end

    factory :content_block_with_credentials do
      after(:create) { |content_block, _e| create(:credential_pair, api_key: content_block.api_key) }
    end
  end
end
