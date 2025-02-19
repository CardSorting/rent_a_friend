class BookingMailer < ApplicationMailer
  def booking_confirmed(booking)
    @booking = booking
    @user = booking.user
    @friend = booking.friend

    mail(
      to: [@user.email, @friend.user.email],
      subject: "Booking Confirmed - #{@friend.user.full_name} and #{@user.full_name}"
    )
  end

  def booking_cancelled(booking)
    @booking = booking
    @user = booking.user
    @friend = booking.friend

    mail(
      to: [@user.email, @friend.user.email],
      subject: "Booking Cancelled - #{@friend.user.full_name} and #{@user.full_name}"
    )
  end

  def request_feedback(booking)
    @booking = booking
    @user = booking.user
    @friend = booking.friend

    mail(
      to: @user.email,
      subject: "How was your time with #{@friend.user.full_name}?"
    )
  end

  def reminder(booking)
    @booking = booking
    @user = booking.user
    @friend = booking.friend

    mail(
      to: [@user.email, @friend.user.email],
      subject: "Upcoming Booking Reminder - #{@friend.user.full_name} and #{@user.full_name}"
    )
  end
end
