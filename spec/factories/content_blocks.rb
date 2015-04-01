FactoryGirl.define do
  factory :content_block, class: ContentBlock do
    content Faker::Lorem.paragraph
  end
end
