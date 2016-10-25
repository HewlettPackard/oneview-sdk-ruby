require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::LogicalEnclosure
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  describe '#remove' do
    it 'removes the resource' do
      item = klass.find_by($client_300, name: LOG_ENCL1_NAME).first
      expect { item.delete }.not_to raise_error
    end
  end
end
