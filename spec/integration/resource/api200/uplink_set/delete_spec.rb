require 'spec_helper'

klass = OneviewSDK::UplinkSet
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#delete' do
    it 'delete resource' do
      item = OneviewSDK::UplinkSet.new($client, name: UPLINK_SET_NAME)
      item.retrieve!
      expect { item.delete }.not_to raise_error
    end
  end
end
