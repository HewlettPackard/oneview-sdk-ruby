require 'spec_helper'

RSpec.describe OneviewSDK::UnmanagedDevice, integration: true, type: UPDATE do
  include_context 'integration context'

  describe '#update' do
    it 'should change name' do
      item = OneviewSDK::UnmanagedDevice.new($client, name: UNMANAGED_DEVICE1_NAME)
      item.retrieve!
      item.update(name: 'UnmanagedDevice_1_Updated')
      item.refresh
      expect(item['name']).to eq('UnmanagedDevice_1_Updated')
      item.update(name: UNMANAGED_DEVICE1_NAME)
    end
  end
end
