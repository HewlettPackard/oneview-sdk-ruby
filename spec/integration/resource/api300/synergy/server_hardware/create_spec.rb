require 'spec_helper'

klass = OneviewSDK::API300::Synergy::ServerHardware
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  describe '#add' do
    it 'is a pending test due to no synergy schematics containing iLOs'
  end
end
