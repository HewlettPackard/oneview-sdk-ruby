require 'spec_helper'

RSpec.describe OneviewSDK::ServerHardwareType do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::ServerHardwareType.new(@client)
      expect(item[:type]).to eq('server-hardware-type-4')
    end
  end

  describe '#create' do
    it 'does not allow it' do
      item = OneviewSDK::ServerHardwareType.new(@client)
      expect { item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe '#save' do
    it 'requires a uri' do
      expect { OneviewSDK::ServerHardwareType.new(@client).save }.to raise_error(/Please set uri/)
    end

    it 'only includes the name and description in the PUT' do
      item = OneviewSDK::ServerHardwareType.new(@client, uri: '/rest/fake', name: 'Name', description: 'Desc', key: 'Val')
      data = { 'body' => { 'name' => 'Name', 'description' => 'Desc' } }
      expect(@client).to receive(:rest_put).with('/rest/fake', data, item.api_version).and_return(FakeResponse.new)
      item.save
    end
  end
end
