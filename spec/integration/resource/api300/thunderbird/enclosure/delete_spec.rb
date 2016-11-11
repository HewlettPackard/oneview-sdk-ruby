require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::Enclosure
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  describe "#remove #{klass}" do
    it 'is a pending test due to removing Enclosures on thunderbird requiring them to be physically removed first'
  end

end
