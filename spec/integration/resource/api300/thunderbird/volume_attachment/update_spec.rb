require 'spec_helper'

RSpec.describe OneviewSDK::API300::Thunderbird::VolumeAttachment, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  describe '#update' do
    it 'should throw unavailable exception' do
      item = OneviewSDK::API300::Thunderbird::VolumeAttachment.new($client_300)
      expect { item.update }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end
end
