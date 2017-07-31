require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::Fabric do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::Fabric
  end

  describe 'Unavaible methods' do
    it '#create' do
      item = OneviewSDK::API300::Synergy::Fabric.new(@client_300, 'name' => 'unit_fabric')
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable, /unavailable for this resource/)
    end

    it '#update' do
      item = OneviewSDK::API300::Synergy::Fabric.new(@client_300, 'name' => 'unit_fabric')
      expect { item.update }.to raise_error(OneviewSDK::MethodUnavailable, /unavailable for this resource/)
    end

    it '#delete' do
      item = OneviewSDK::API300::Synergy::Fabric.new(@client_300, 'name' => 'unit_fabric')
      expect { item.delete }.to raise_error(OneviewSDK::MethodUnavailable, /unavailable for this resource/)
    end

    it '#refresh' do
      item = OneviewSDK::API300::Synergy::Fabric.new(@client_300, 'name' => 'unit_fabric')
      expect { item.refresh }.to raise_error(OneviewSDK::MethodUnavailable, /unavailable for this resource/)
    end
  end

  describe '#get_reserved_vlan_range' do
    it 'gets the reserved vlan range attributes successfully' do
      item = OneviewSDK::API300::Synergy::Fabric.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with("#{item['uri']}/reserved-vlan-range", {}, item.api_version)
        .and_return(FakeResponse.new([{ start: 105, length: 105, type: 'vlan-pool' }]))
      expect { item.get_reserved_vlan_range }.not_to raise_error
    end
  end

  describe '#set_reserved_vlan_range' do
    it 'sets new reserved vlan range attributes successfully' do
      options = { start: 105, length: 105, type: 'vlan-pool' }
      item = OneviewSDK::API300::Synergy::Fabric.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_put).with("#{item['uri']}/reserved-vlan-range", { 'body' => options }, item.api_version)
        .and_return(FakeResponse.new(options))
      expect { item.set_reserved_vlan_range(options) }.not_to raise_error
    end
  end
end
