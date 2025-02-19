class User < ApplicationRecord
  # Include default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  # Relationships
  has_one :friend
  has_many :bookings
  has_many :booked_friends, through: :bookings, source: :friend

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  # Methods
  def full_name
    "#{first_name} #{last_name}"
  end

  def friend?
    friend.present?
  end

  def can_book?(friend, start_time, end_time)
    return false if friend.nil? || start_time.nil? || end_time.nil?
    return false if friend.user_id == id # Can't book yourself
    return false if start_time >= end_time
    return false if start_time < Time.current
    
    # Check if friend has available time slot
    friend.available_between?(start_time, end_time)
  end
end
