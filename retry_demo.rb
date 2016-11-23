RECHECK_DELAY_SECONDS = 0.25

def time_is_up?(start:, timeout:)
  Time.now > (start + timeout)
end

# Retry a block of code until success
#
# @param with_timeout timeout in seconds
# @param &block code to retry, which returns a falsey value on failure
# @return {success: Boolean, result: Result if code was successful}
def retry_this(with_timeout:)
  result = nil
  start_time = Time.now

  loop do
    result = yield
    break if result || time_is_up?(start: start_time, timeout: with_timeout)
    sleep RECHECK_DELAY_SECONDS
  end

  if result
    { success: true,  result: result }
  else
    { success: false, reason: 'Timed out' }
  end
end

# Test this
result = retry_this(with_timeout: 5)
puts "got result: #{result}"
