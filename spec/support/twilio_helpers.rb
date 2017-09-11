module TwilioHelpers
  def twilio
    @_twilio ||= Twilio::REST::Client.new TWILIO_SID, TWILIO_TOKEN
  end

  def get_otp(after_date=nil)
    count = 0
    max_count = 5
    twilio.messages.list(date_sent: after_date).first.body[0..5]
  rescue NoMethodError
    count += 1
    puts "OTP not found yet, sleeping 2 seconds and trying again. Attempt #{count} of #{max_count}."
    sleep 2
    exit if count > max_count
    retry
  end
end
