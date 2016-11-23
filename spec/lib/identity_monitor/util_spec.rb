# frozen_string_literal: true
require 'spec_helper'
require 'identity_monitor/util'

RSpec.describe IdentityMonitor::Util do
  describe '#retry_this' do
    it 'throws LocalJumpError if not passed a block' do
      expect { IdentityMonitor::Util.retry_this(with_timeout: 5) }.to raise_error(LocalJumpError)
    end

    it 'returns failure status when provided block that cannot pass'
  end
end
