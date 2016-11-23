# frozen_string_literal: true
require 'twilio-ruby'
require 'sinatra'

# http://www.sinatrarb.com/configuration.html
set :port, 4567
set :bind, '0.0.0.0'


post '/sms' do
  body = params['Body']
  puts "Got an SMS with contents: #{body}"
end


post '/MessageStatus' do
  message_sid    = params.fetch('MessageSid')
  message_status = params.fetch('MessageStatus')

  puts "SID: #{message_sid}, Status: #{message_status}"

  response.status = 204
end
