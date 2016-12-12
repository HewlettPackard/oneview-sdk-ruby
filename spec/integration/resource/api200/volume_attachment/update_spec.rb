require 'spec_helper'

RSpec.describe OneviewSDK::VolumeAttachment, integration: true, type: UPDATE do
  include_context 'integration context'

  describe '#update' do
    it 'should throw unavailable exception' do
      item = OneviewSDK::VolumeAttachment.new($client)
      expect { item.update }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end
end
