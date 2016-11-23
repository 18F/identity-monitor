# frozen_string_literal: true
module IdentityMonitor
  module Util
    RECHECK_DELAY_SECONDS  = 0.25
    TIMEOUT_REASON_MSG     = 'Timed out'

    module_function

    # Retry a block of code until success
    #
    # @param with_timeout timeout in seconds
    # @param block        code to retry, which returns a falsey value on failure
    # @return {success: Boolean, result: Result if code was successful}
    def retry_this(with_timeout:)
      output     = nil
      start_time = Time.now

      loop do
        output = yield
        break if output || time_is_up?(start: start_time, timeout: with_timeout)
        sleep RECHECK_DELAY_SECONDS
      end

      structured_return(result: output, reason: TIMEOUT_REASON_MSG)
    end

    # @param start   start time as a Time object
    # @param timeout timeout duration expressed in seconds
    def time_is_up?(start:, timeout:)
      Time.now > (start + timeout)
    end

    # Create an Elixir-style union type return value.
    # TODO: Refactor into a class if used more.
    def structured_return(result:, reason:)
      {
        success: !!result
      }.merge(
        result ? { result: result } : { reason: reason }
      )
    end
  end
end
