require 'spec_helper'

klass = OneviewSDK::VolumeAttachment
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#delete' do
    it 'should throw unavailable exception' do
      item = OneviewSDK::VolumeAttachment.new($client)
      expect { item.delete }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end
end
