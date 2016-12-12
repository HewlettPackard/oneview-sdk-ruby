require 'spec_helper'

klass = OneviewSDK::API300::C7000::UnmanagedDevice
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  describe '#create' do
    it 'should throw unavailable exception' do
      item = klass.new($client_300, name: UNMANAGED_DEVICE1_NAME, model: 'Unknown')
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#add' do
    it 'Add unmanaged device' do
      item = klass.new($client_300, name: UNMANAGED_DEVICE1_NAME, model: 'Unknown')
      item.add
      expect(item['uri']).to be
    end
  end

  describe '#environmentalConfiguration' do
    it 'Gets the script' do
      item = klass.find_by($client_300, {}).first
      result = item.environmental_configuration
      expect(result).to be
      expect(result.class).to eq(Hash)
    end
  end

  describe '#self.get_devices' do
    it 'Check if created device is present' do
      item = klass.find_by($client_300, {}).first
      devices = klass.get_devices($client_300)
      expect(devices).to include(item.data)
    end
  end
end
