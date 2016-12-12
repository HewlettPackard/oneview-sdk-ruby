require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::UnmanagedDevice
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  describe '#update' do
    it 'should change name' do
      item = klass.new($client_300, name: UNMANAGED_DEVICE1_NAME)
      item.retrieve!
      item.update(name: 'UnmanagedDevice_1_Updated')
      item.refresh
      expect(item['name']).to eq('UnmanagedDevice_1_Updated')
      item.update(name: UNMANAGED_DEVICE1_NAME)
    end
  end
end
