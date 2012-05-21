FactoryGirl.define do
  
  factory :post do
    sequence(:title) { |n| "Test Post #{n}" }
    body "This is just a test post"
  end
  
end
