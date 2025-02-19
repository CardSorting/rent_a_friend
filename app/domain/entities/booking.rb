class Booking < ApplicationRecord
  include AASM

  # Relationships
  belongs_to :friend
  belongs_to :user
  belongs_to :service_category

  # Money handling
  monetize :total_amount_cents

  # Validations
  validates :start_time, :end_time, presence: true
  validates :status, presence: true
  validates :total_amount, presence: true,
            numericality: { greater_than_or_equal_to: 0 }
  validate :end_time_after_start_time
  validate :friend_available, on: :create
  validate :not_booking_self
  validate :start_time_in_future, on: :create

  # Scopes
  scope :upcoming, -> { where('start_time > ?', Time.current) }
  scope :past, -> { where('end_time < ?', Time.current) }
  scope :current, -> {
    where('start_time <= ? AND end_time >= ?', Time.current, Time.current)
  }

  # State machine
  aasm column: :status do
    state :pending, initial: true
    state :confirmed, :completed, :cancelled

    event :confirm do
      transitions from: :pending, to: :confirmed
      after do
        # Block the time slot
        friend.block_time(start_time, end_time)
        # Send confirmation emails
        BookingMailer.booking_confirmed(self).deliver_later
        # Schedule reminder email
        SendBookingReminderJob.schedule_reminder(self)
      end
    end

    event :complete do
      transitions from: :confirmed, to: :completed
      after do
        # Send feedback request
        BookingMailer.request_feedback(self).deliver_later
      end
    end

    event :cancel do
      transitions from: [:pending, :confirmed], to: :cancelled
      after do
        if confirmed?
          # Free up the time slot if it was confirmed
          friend.add_available_time(start_time, end_time)
        end
        # Send cancellation notification
        BookingMailer.booking_cancelled(self).deliver_later
      end
    end
  end

  # Callbacks
  before_validation :calculate_total_amount, on: :create

  # Methods
  def duration
    (end_time - start_time) / 1.hour
  end

  def can_be_cancelled?
    (pending? || confirmed?) && start_time > Time.current
  end

  def can_be_completed?
    confirmed? && end_time <= Time.current
  end

  private

  def calculate_total_amount
    return if friend.nil? || start_time.nil? || end_time.nil?
    self.total_amount = friend.calculate_total_amount(start_time, end_time)
  end

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end

  def friend_available
    return if friend.nil? || start_time.nil? || end_time.nil?

    unless friend.available_between?(start_time, end_time)
      errors.add(:base, "Friend is not available during this time period")
    end
  end

  def not_booking_self
    return if friend.nil? || user.nil?

    if friend.user_id == user_id
      errors.add(:base, "You cannot book yourself")
    end
  end

  def start_time_in_future
    return if start_time.blank?

    if start_time <= Time.current
      errors.add(:start_time, "must be in the future")
    end
  end
end
