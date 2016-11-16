require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::LogicalSwitchGroup
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  describe '#update' do
    it 'self raises MethodUnavailable' do
      item = klass.new($client_300_thunderbird, name: LOG_SWI_GROUP_NAME)
      expect { item.update }.to raise_error(/The method #update is unavailable for this resource/)
    end
  end
end
