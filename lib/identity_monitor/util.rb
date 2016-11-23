# frozen_string_literal: true
module IdentityMonitor
  module Util
    RECHECK_DELAY_SECONDS  = 0.25
    TIMEOUT_REASON_MSG     = 'Timed out'

    module_function

    # Retry a block of code until success
    #
    # @param with_timeout timeout in seconds
    # @param &block code to retry, which returns a falsey value on failure
    # @return {success: Boolean, result: Result if code was successful}
    def retry_this(with_timeout:)
      output     = nil
      start_time = Time.now

      loop do
        output = yield
        break if output || time_is_up?(start: start_time, timeout: with_timeout)
        sleep RECHECK_DELAY_SECONDS
      end

      structured_return(result: output)
    end

    def time_is_up?(start:, timeout:)
      Time.now > (start + timeout)
    end

    # Create an Elixir-style union type return value.
    def structured_return(result:)
      {
        success: !!result
      }.merge(
        result ? { result: result } : { reason: TIMEOUT_REASON_MSG }
      )
    end
  end
end
