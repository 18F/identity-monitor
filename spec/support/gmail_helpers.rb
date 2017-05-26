module GmailHelpers
  def gmail
    @_gmail ||= Gmail.connect!(EMAIL, EMAIL_PASSWORD)
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

  def current_otp_from_email
    inbox_unread.each do |email|
      msg = email.message.parts[0].body
      otp = msg.match(/(\d+) is your login.gov one-time/)
      if otp
        email.read!
        return otp[1]
      end
    end
    nil
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

  def check_for_otp
    check_inbox_for_email_value('OTP') do
      current_otp_from_email
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

  # rubocop:disable MethodLength
  def check_inbox_for_email_value(label)
    value = nil
    counter = 0
    until value
      sleep 2
      puts "checking for #{label} ..."
      value = yield
      counter += 1
      if counter >= 60
        puts "giving up #{label} check ... timed out"
        break
      end
    end
    raise "cannot find #{label}" unless value
    value
  end
  # rubocop:enable MethodLength
end
