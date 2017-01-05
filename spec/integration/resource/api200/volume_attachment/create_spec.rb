require 'spec_helper'

klass = OneviewSDK::VolumeAttachment
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration context'

  describe '#create' do
    it 'should throw unavailable exception' do
      item = klass.new($client)
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end
end
