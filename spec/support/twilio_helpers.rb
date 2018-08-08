module TwilioHelpers
  def twilio
    @twilio ||= Twilio::REST::Client.new TWILIO_SID, TWILIO_TOKEN
  end

  def get_otp(count = 0, date = Time.now - 5)
    max_count = 10
    phone = "+1#{TWILIO_PHONE}"
    twilio.messages.list(date_sent_after: date, to: phone).first.body[0..5]
  rescue NoMethodError
    count += 1
    sleep 2
    raise 'Tried too many times' if count > max_count
    puts "OTP not found yet, sleeping 2 seconds and trying again. Attempt #{count} of #{max_count}."
    retry
  end
end
