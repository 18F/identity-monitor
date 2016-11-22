require 'twilio-ruby'
require 'sinatra'


post '/sms' do
  body = params['Body']
  puts body
end
