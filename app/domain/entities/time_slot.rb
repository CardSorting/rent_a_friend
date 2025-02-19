class TimeSlot < ApplicationRecord
  # Relationships
  belongs_to :friend

  # Validations
  validates :start_time, :end_time, presence: true
  validates :friend, presence: true
  validate :end_time_after_start_time
  validate :no_overlapping_slots
  validate :start_time_in_future, on: :create

  # Scopes
  scope :available, -> { where(available: true) }
  scope :upcoming, -> { where('start_time > ?', Time.current) }
  scope :overlapping, ->(start_time, end_time) {
    where('start_time < ? AND end_time > ?', end_time, start_time)
  }
  scope :for_date, ->(date) {
    where(start_time: date.beginning_of_day..date.end_of_day)
  }

  # Methods
  def duration
    (end_time - start_time) / 1.hour
  end

  def contains?(start_time, end_time)
    self.start_time <= start_time && self.end_time >= end_time
  end

  def overlaps?(start_time, end_time)
    self.start_time < end_time && self.end_time > start_time
  end

  def can_be_booked?
    available? && start_time > Time.current
  end

  def mark_as_unavailable!
    update!(available: false)
  end

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end

  def no_overlapping_slots
    return if start_time.blank? || end_time.blank?

    overlapping_slots = friend.time_slots
                             .where.not(id: id) # Exclude self when updating
                             .overlapping(start_time, end_time)

    if overlapping_slots.exists?
      errors.add(:base, "Overlaps with existing time slots")
    end
  end

  def start_time_in_future
    return if start_time.blank?

    if start_time <= Time.current
      errors.add(:start_time, "must be in the future")
    end
  end
end
