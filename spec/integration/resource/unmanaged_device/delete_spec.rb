require 'spec_helper'

RSpec.describe OneviewSDK::UnmanagedDevice, integration: true, type: DELETE, sequence: 15 do
  include_context 'integration context'

  describe '#remove' do
    it 'remove resource' do
      item = OneviewSDK::UnmanagedDevice.new($client, name: UNMANAGED_DEVICE1_NAME)
      item.retrieve!
      expect { item.remove }.to_not raise_error
    end
  end

end
