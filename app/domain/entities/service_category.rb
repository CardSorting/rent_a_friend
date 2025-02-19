class ServiceCategory < ApplicationRecord
  # Relationships
  has_and_belongs_to_many :friends
  has_many :bookings

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  # Scopes
  scope :active, -> { where(active: true) }
  scope :with_available_friends, -> {
    joins(:friends)
      .where(friends: { active: true })
      .distinct
  }

  # Methods
  def available_friends_between(start_time, end_time)
    return [] if start_time.nil? || end_time.nil? || start_time >= end_time

    friends.active.select { |friend| friend.available_between?(start_time, end_time) }
  end

  def popular_time_slots
    # Returns the most commonly booked time slots for this category
    bookings
      .where(status: 'completed')
      .group_by_hour_of_day(:start_time)
      .count
      .sort_by { |_, count| -count }
  end

  def average_duration
    completed_bookings = bookings.where(status: 'completed')
    return 0 if completed_bookings.empty?

    total_duration = completed_bookings.sum do |booking|
      (booking.end_time - booking.start_time) / 1.hour
    end

    (total_duration / completed_bookings.count).round(1)
  end

  def average_price
    completed_bookings = bookings.where(status: 'completed')
    return Money.new(0) if completed_bookings.empty?

    total_amount = completed_bookings.sum { |booking| booking.total_amount_cents }
    Money.new(total_amount / completed_bookings.count)
  end
end
