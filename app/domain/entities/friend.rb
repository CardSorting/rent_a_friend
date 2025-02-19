class Friend < ApplicationRecord
  # Relationships
  belongs_to :user
  has_many :time_slots, dependent: :destroy
  has_many :bookings
  has_many :clients, through: :bookings, source: :user
  has_and_belongs_to_many :service_categories

  # Money handling
  monetize :hourly_rate_cents

  # Validations
  validates :bio, presence: true
  validates :hourly_rate, presence: true,
            numericality: { greater_than_or_equal_to: 0 }
  validates :user_id, presence: true, uniqueness: true

  # Scopes
  scope :active, -> { where(active: true) }
  scope :available_on, ->(date) { 
    joins(:time_slots)
      .where(time_slots: { 
        start_time: date.beginning_of_day..date.end_of_day,
        available: true 
      })
      .distinct
  }

  # Methods
  def available_between?(start_time, end_time)
    return false unless active?
    return false if start_time >= end_time
    
    # Check if there's an available time slot that covers the entire period
    time_slots.available.exists?(
      "start_time <= ? AND end_time >= ?", 
      start_time, end_time
    )
  end

  def calculate_total_amount(start_time, end_time)
    return Money.new(0) if start_time.nil? || end_time.nil?
    
    duration_in_hours = (end_time - start_time) / 1.hour
    hourly_rate * duration_in_hours
  end

  def upcoming_bookings
    bookings.where("start_time > ?", Time.current)
            .order(start_time: :asc)
  end

  def past_bookings
    bookings.where("end_time < ?", Time.current)
            .order(start_time: :desc)
  end

  def block_time(start_time, end_time)
    return false if start_time >= end_time
    
    # Find overlapping available time slots
    overlapping_slots = time_slots.available.where(
      "start_time < ? AND end_time > ?",
      end_time, start_time
    )

    return false if overlapping_slots.empty?

    # Split or update existing time slots to block the requested time
    overlapping_slots.each do |slot|
      if slot.start_time < start_time && slot.end_time > end_time
        # Split into two slots
        time_slots.create!(start_time: slot.start_time, end_time: start_time, available: true)
        time_slots.create!(start_time: end_time, end_time: slot.end_time, available: true)
        slot.destroy
      elsif slot.start_time < start_time
        # Update end time
        slot.update!(end_time: start_time)
      elsif slot.end_time > end_time
        # Update start time
        slot.update!(start_time: end_time)
      else
        # Complete overlap, mark as unavailable
        slot.update!(available: false)
      end
    end

    true
  end

  def add_available_time(start_time, end_time)
    return false if start_time >= end_time
    
    # Check for overlapping slots
    overlapping_slots = time_slots.where(
      "start_time < ? AND end_time > ?",
      end_time, start_time
    )

    if overlapping_slots.empty?
      # No overlap, create new slot
      time_slots.create!(
        start_time: start_time,
        end_time: end_time,
        available: true
      )
    else
      # Merge overlapping slots
      earliest_start = [start_time, overlapping_slots.minimum(:start_time)].min
      latest_end = [end_time, overlapping_slots.maximum(:end_time)].max
      
      overlapping_slots.destroy_all
      time_slots.create!(
        start_time: earliest_start,
        end_time: latest_end,
        available: true
      )
    end

    true
  end
end
