require 'spec_helper'

klass = OneviewSDK::API500::C7000::LogicalSwitchGroup
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api500 context'

  describe '#delete' do
    it 'removes all the Logical Switch groups' do
      item = klass.new($client_500, name: LOG_SWI_GROUP_NAME)
      item.retrieve!
      expect { item.delete }.to_not raise_error
      item = klass.find_by($client_500, name: LOG_SWI_GROUP_NAME)
      expect(item).to be_empty
    end
  end
end
