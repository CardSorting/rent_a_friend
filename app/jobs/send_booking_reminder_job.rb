class SendBookingReminderJob < ApplicationJob
  queue_as :default

  def perform(booking_id)
    booking = Booking.find_by(id: booking_id)
    return unless booking && booking.confirmed? && booking.start_time > Time.current

    BookingMailer.reminder(booking).deliver_now
  end

  # Schedule the reminder email 24 hours before the booking
  def self.schedule_reminder(booking)
    reminder_time = booking.start_time - 24.hours
    
    # Only schedule if the booking is more than 24 hours away
    if reminder_time > Time.current
      set(wait_until: reminder_time).perform_later(booking.id)
    end
  end
end
