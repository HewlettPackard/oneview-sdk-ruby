require 'spec_helper'

klass = OneviewSDK::UnmanagedDevice
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration context'

  describe '#create' do
    it 'should throw unavailable exception' do
      item = klass.new($client, name: UNMANAGED_DEVICE1_NAME, model: 'Unknown')
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#add' do
    it 'Add unmanaged device' do
      item = klass.new($client, name: UNMANAGED_DEVICE1_NAME, model: 'Unknown')
      item.add
      expect(item['uri']).to be
    end
  end

  describe '#environmental_configuration' do
    it 'Gets the script' do
      item = klass.find_by($client, {}).first
      result = item.environmental_configuration
      expect(result).to be
      expect(result.class).to eq(Hash)
    end
  end

  describe '::get_devices' do
    it 'Check if created device is present' do
      item = klass.find_by($client, {}).first
      devices = klass.get_devices($client)
      expect(devices).to include(item.data)
    end
  end
end
