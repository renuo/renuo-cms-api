FactoryGirl.define do
  factory :content_block, class: ContentBlock do
    sequence(:content_path) { |i| "path-#{i}" }
    content "<h1>#{Faker::Lorem.word}</h1><p>#{Faker::Lorem.paragraph}<br/>#{Faker::Lorem.paragraph}</p>"
  end
end
