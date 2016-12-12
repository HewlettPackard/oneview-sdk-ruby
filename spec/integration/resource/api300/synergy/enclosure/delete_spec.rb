require 'spec_helper'

klass = OneviewSDK::API300::Synergy::Enclosure
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  describe "#remove #{klass}" do
    it 'is an absent test since removing Enclosures on Synergy requires them to be physically removed first'
  end

end
