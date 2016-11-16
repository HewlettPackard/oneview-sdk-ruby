require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::LogicalSwitchGroup
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  describe '#delete' do
    it 'self raises MethodUnavailable' do
      item = klass.new($client_300_thunderbird, name: LOG_SWI_GROUP_NAME)
      expect { item.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end
end
