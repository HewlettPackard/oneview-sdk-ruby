require 'spec_helper'

klass = OneviewSDK::API600::Synergy::ServerHardware
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api600 context'

  describe '#add' do
    it 'is a pending test due to no synergy schematics containing iLOs'
  end
end
