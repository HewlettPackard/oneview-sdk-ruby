require 'spec_helper'

RSpec.describe OneviewSDK::VolumeTemplate, integration: true, type: UPDATE do
  include_context 'integration context'

  describe '#retrieve!' do
    it 'retrieves the resource' do
      item = OneviewSDK::VolumeTemplate.new(@client, name: 'ONEVIEW_SDK_TEST VT1')
      item.retrieve!
      expect(item[:name]).to eq('ONEVIEW_SDK_TEST VT1')
      expect(item[:description]).to eq('Volume Template')
      expect(item[:stateReason]).to eq('None')
      expect(item[:type]).to eq('StorageVolumeTemplateV3')
    end
  end

  describe '#update' do
    it 'update ONEVIEW_SDK_TEST VT1' do
      item = OneviewSDK::VolumeTemplate.new(@client, name: 'ONEVIEW_SDK_TEST VT1')
      item.retrieve!
      item.update(name: 'ONEVIEW_SDK_TEST VT2')
      item.refresh
      expect(item[:name]).to eq('ONEVIEW_SDK_TEST VT2')
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = OneviewSDK::VolumeTemplate.find_by(@client, {}).map { |item| item[:name] }
      expect(names).to include('ONEVIEW_SDK_TEST VT2')
    end

    it 'finds networks by multiple attributes' do
      attrs = { name: 'ONEVIEW_SDK_TEST VT2', type: 'StorageVolumeTemplateV3' }
      names = OneviewSDK::VolumeTemplate.find_by(@client, attrs).map { |item| item[:name] }
      expect(names).to include('ONEVIEW_SDK_TEST VT2')
    end
  end
end
