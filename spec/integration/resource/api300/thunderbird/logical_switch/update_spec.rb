require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::LogicalSwitch
RSpec.describe klass, integration: true, type: UPDATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  describe '#get_internal_link_sets' do
    it 'gets the internal link sets' do
      expect { klass.get_internal_link_sets($client_300) }.not_to raise_error
    end
  end
end
