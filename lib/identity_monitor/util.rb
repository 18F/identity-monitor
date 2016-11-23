# frozen_string_literal: true
module IdentityMonitor
  module Util
    RECHECK_DELAY_SECONDS  = 0.25
    TIMEOUT_REASON_MESSAGE = 'Timed out'

    module_function

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
        { success: false, reason: TIMEOUT_REASON_MSG }
      end
    end

    def time_is_up?(start:, timeout:)
      Time.now > (start + timeout)
    end
  end
end
