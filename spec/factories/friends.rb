FactoryBot.define do
  factory :friend do
    user { nil }
    bio { "MyText" }
    hourly_rate { "9.99" }
  end
end
