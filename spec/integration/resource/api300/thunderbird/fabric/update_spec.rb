require 'spec_helper'

klass = OneviewSDK::API300::Synergy::Fabric
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  describe 'GET' do
    it 'by #find_by' do
      item = klass.find_by($client_300_synergy, {}).first
      expect(item).to be
    end

    it 'by #retrieve!' do
      item = klass.new($client_300_synergy, 'name' => DEFAULT_FABRIC_NAME)
      expect { item.retrieve! }.to_not raise_error
      expect(item['uri']).to be
    end
  end

  describe '#get_reserved_vlan_range' do
    it 'gets the reserved vlan range attributes successfully' do
      item = klass.find_by($client_300_synergy, {}).first
      expect { item.get_reserved_vlan_range }.not_to raise_error
    end
  end

  describe '#set_reserved_vlan_range' do
    it 'sets new reserved vlan range attributes successfully' do
      item = klass.find_by($client_300_synergy, {}).first
      expect { item.set_reserved_vlan_range(start: 105, length: 105, type: 'vlan-pool') }.not_to raise_error
      expect(item.get_reserved_vlan_range['start']).to eq(105)
      expect { item.set_reserved_vlan_range(start: 100, length: 100, type: 'vlan-pool') }.not_to raise_error
      expect(item.get_reserved_vlan_range['start']).to eq(100)
    end
  end
end
