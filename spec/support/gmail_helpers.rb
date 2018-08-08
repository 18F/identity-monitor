module GmailHelpers
  def gmail
    @gmail ||= Gmail.connect!(EMAIL, EMAIL_PASSWORD)
  end

  def inbox_unread
    gmail.inbox.emails(:unread)
  end

  def inbox_clear
    inbox_unread.each do |email|
      puts "Marking #{email.subject} as unread"
      email.read!
    end
    gmail.inbox.emails(:read).each(&:delete!)
  end

  def current_otp_from_email(option)
    inbox_unread.each do |email|
      msg = email.message.parts[0].body
      if option == 'sms'
        otp = msg.match(/(\d+) is your login.gov/)[1]
      elsif option == 'voice'
        otp = msg.match(/passcode is (\d+\s?\d+)\s?(one|to|for|hate)?/)
        if otp[2]
          last_digit = digit_from_word[otp[2]]
          otp = otp[1] + last_digit
        else
          otp = otp[1].delete(' ')
        end
        puts "passcode as transcribed by Google Voice is: #{otp}"
      end
      if otp
        email.read!
        return otp
      end
    end
    nil
  end

  def digit_from_word
    {
      'one' => '1',
      'to' => '2',
      'for' => '4',
      'hate' => '8'
    }
  end

  def current_confirmation_link
    inbox_unread.each do |email|
      next unless email.subject == 'Confirm your email'
      msg = email.message.parts[0].body
      url = msg.match(/(https:.+confirmation_token=[\w\-]+)/)
      if url
        email.read!
        return url[1]
      end
    end
    nil
  end

  def current_password_reset_link
    inbox_unread.each do |email|
      next unless email.subject == 'Reset your password'
      msg = email.message.parts[0].body
      url = msg.match(/(https:.+reset_password_token=[\w\-]+)/)
      if url
        email.read!
        return url[1]
      end
    end
    nil
  end

  def check_for_otp(option:)
    check_inbox_for_email_value('OTP') do
      current_otp_from_email(option)
    end
  end

  def check_for_confirmation_link
    check_inbox_for_email_value('confirmation URL') do
      current_confirmation_link
    end
  end

  def check_for_password_reset_link
    check_inbox_for_email_value('password reset URL') do
      current_password_reset_link
    end
  end

  def check_inbox_for_email_value(label)
    value = nil
    counter = 0
    until value
      sleep 2
      puts "checking for #{label} ..."
      value = yield
      counter += 1
      if counter >= 120
        puts "giving up #{label} check ... timed out"
        break
      end
    end
    raise "cannot find #{label}" unless value
    value
  end
end
