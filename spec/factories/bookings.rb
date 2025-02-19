FactoryBot.define do
  factory :booking do
    friend { nil }
    user { nil }
    service_category { nil }
    start_time { "2025-02-19 11:02:57" }
    end_time { "2025-02-19 11:02:57" }
    status { "MyString" }
    total_amount { "9.99" }
  end
end
