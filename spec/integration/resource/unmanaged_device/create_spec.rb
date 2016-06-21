require 'spec_helper'

RSpec.describe OneviewSDK::UnmanagedDevice, integration: true, type: CREATE, sequence: 15 do
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

end
