require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::VolumeTemplate
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  before :each do
    @item = klass.new($client_300, name: VOL_TEMP_NAME)
  end

  describe '#retrieve!' do
    it 'retrieves the resource' do
      @item.retrieve!
      expect(@item[:name]).to eq(VOL_TEMP_NAME)
      expect(@item[:description]).to eq('Volume Template')
      expect(@item[:stateReason]).to eq('None')
      expect(@item[:type]).to eq('StorageVolumeTemplateV3')
    end
  end

  describe '#update' do
    it 'update volume name' do
      @item.retrieve!

      @item.update(name: VOL_TEMP_NAME_UPDATED)
      @item.refresh
      expect(@item[:name]).to eq(VOL_TEMP_NAME_UPDATED)

      @item.update(name: VOL_TEMP_NAME)
      @item.refresh
      expect(@item[:name]).to eq(VOL_TEMP_NAME)
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = klass.find_by($client_300, {}).map { |item| item[:name] }
      expect(names).to include(VOL_TEMP_NAME)
    end

    it 'finds networks by multiple attributes' do
      attrs = { name: VOL_TEMP_NAME }
      names = klass.find_by($client_300, attrs).map { |item| item[:name] }
      expect(names).to include(VOL_TEMP_NAME)
    end
  end
end
