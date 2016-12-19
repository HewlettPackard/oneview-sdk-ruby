require 'spec_helper'

klass = OneviewSDK::API300::Synergy::UplinkSet
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  describe '#delete' do
    it 'delete resource' do
      item = klass.new($client_300_synergy, name: UPLINK_SET3_NAME)
      item.retrieve!
      expect { item.delete }.not_to raise_error
      expect(item.retrieve!).to eq(false)
    end
  end
end
