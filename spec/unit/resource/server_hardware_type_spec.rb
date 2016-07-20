require 'spec_helper'

RSpec.describe OneviewSDK::ServerHardwareType do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::ServerHardwareType.new(@client)
      expect(item[:type]).to eq('server-hardware-type-4')
    end
  end

  describe '#update' do
    it 'requires a uri' do
      expect { OneviewSDK::ServerHardwareType.new(@client).update }.to raise_error(/Please set uri/)
    end

    it 'only includes the name and description in the PUT' do
      item = OneviewSDK::ServerHardwareType.new(@client, uri: '/rest/fake', name: 'Name', description: 'Desc', key: 'Val')
      data = { 'body' => { 'name' => 'Name', 'description' => 'Desc' } }
      expect(@client).to receive(:rest_put).with('/rest/fake', data, item.api_version).and_return(FakeResponse.new)
      item.update
    end
  end

  describe '#remove' do
    it 'removes server hardware type' do
      item = OneviewSDK::ServerHardwareType.new(@client, uri: '/rest/server-hardware-types/100')
      expect(@client).to receive(:rest_delete).with('/rest/server-hardware-types/100', {}, item.api_version).and_return(FakeResponse.new)
      item.remove
    end
  end

  describe 'undefined methods' do
    it 'does not allow the create action' do
      server_hardware_type = OneviewSDK::ServerHardwareType.new(@client)
      expect { server_hardware_type.create }.to raise_error(OneviewSDK::MethodUnavailable, /The method #create is unavailable for this resource/)
    end

    it 'does not allow the delete action' do
      server_hardware_type = OneviewSDK::ServerHardwareType.new(@client)
      expect { server_hardware_type.delete }.to raise_error(OneviewSDK::MethodUnavailable, /The method #delete is unavailable for this resource/)
    end
  end
end
