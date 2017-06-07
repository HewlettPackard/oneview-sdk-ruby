require 'spec_helper'

klass = OneviewSDK::API300::Synergy::IDPool
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#delete' do
    it 'raises MethodUnavailable' do
      item = described_class.new($client)
      expect { item.delete }.to raise_error(OneviewSDK::MethodUnavailable, /The method #delete is unavailable for this resource/)
    end
  end
end
