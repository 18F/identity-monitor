# frozen_string_literal: true
require 'spec_helper'
require 'identity_monitor/util'

include IdentityMonitor

RSpec.describe IdentityMonitor::Util do
  describe '#retry_this' do
    it 'throws LocalJumpError if not passed a block' do
      expect { Util.retry_this(with_timeout: 5) }.to raise_error(LocalJumpError)
    end

    it "returns failure status when block doesn't pass" do
      result = Util.retry_this(with_timeout: 0.1) { false }
      expect( result.fetch(:success) ).to be false
    end
  end
end
