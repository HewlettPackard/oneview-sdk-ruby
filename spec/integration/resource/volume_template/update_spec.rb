require 'spec_helper'

RSpec.describe OneviewSDK::VolumeTemplate, integration: true, type: UPDATE do
  include_context 'integration context'

  describe '#retrieve!' do
    it 'retrieves the resource' do
      item = OneviewSDK::VolumeTemplate.new($client, name: VOL_TEMP_NAME)
      item.retrieve!
      expect(item[:name]).to eq(VOL_TEMP_NAME)
      expect(item[:description]).to eq('Volume Template')
      expect(item[:stateReason]).to eq('None')
      expect(item[:type]).to eq('StorageVolumeTemplateV3')
    end
  end

  describe '#update' do
    it 'update volume name' do
      item = OneviewSDK::VolumeTemplate.new($client, name: VOL_TEMP_NAME)
      item.retrieve!

      item.update(name: VOL_TEMP_NAME_UPDATED)
      item.refresh
      expect(item[:name]).to eq(VOL_TEMP_NAME_UPDATED)

      item.update(name: VOL_TEMP_NAME)
      item.refresh
      expect(item[:name]).to eq(VOL_TEMP_NAME)
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = OneviewSDK::VolumeTemplate.find_by($client, {}).map { |item| item[:name] }
      expect(names).to include(VOL_TEMP_NAME)
    end

    it 'finds networks by multiple attributes' do
      attrs = { name: VOL_TEMP_NAME, type: 'StorageVolumeTemplateV3' }
      names = OneviewSDK::VolumeTemplate.find_by($client, attrs).map { |item| item[:name] }
      expect(names).to include(VOL_TEMP_NAME)
    end
  end
end
