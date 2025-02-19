class Booking < ApplicationRecord
  belongs_to :friend
  belongs_to :user
  belongs_to :service_category
end
