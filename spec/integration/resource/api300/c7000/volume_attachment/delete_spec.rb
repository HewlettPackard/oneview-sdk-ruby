require 'spec_helper'

klass = OneviewSDK::API300::C7000::VolumeAttachment
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  # Delete operation should be performed through the Server-Profiles API
  describe '#delete' do
    it 'should throw unavailable exception' do
      item = OneviewSDK::API300::C7000::VolumeAttachment.new($client_300)
      expect { item.delete }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end
end
