require 'spec_helper'

klass = OneviewSDK::UnmanagedDevice
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration context'

  describe '#add' do
    it 'Add unmanaged device' do
      item = OneviewSDK::UnmanagedDevice.new($client, name: UNMANAGED_DEVICE1_NAME, model: 'Unknown')
      item.add
      expect(item['uri']).to be
    end
  end

  describe '#environmentalConfiguration' do
    it 'Gets the script' do
      item = OneviewSDK::UnmanagedDevice.find_by($client, {}).first
      expect { item.environmental_configuration }.not_to raise_error
    end
  end

  describe '#self.get_devices' do
    it 'Check if created device is present' do
      devices = OneviewSDK::UnmanagedDevice.get_devices($client)
      devices = devices.map { |device| device['name'] }
      expect(devices).to include(UNMANAGED_DEVICE1_NAME)
    end
  end
end
