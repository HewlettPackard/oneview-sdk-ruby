require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::Interconnect do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::Interconnect
  end

  describe 'undefined methods' do
    before :each do
      @item = OneviewSDK::API300::Synergy::Interconnect.new(@client_300, {})
    end

    it 'does not allow the create action' do
      expect { @item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end

    it 'does not allow the update action' do
      expect { @item.update }.to raise_error(/The method #update is unavailable for this resource/)
    end

    it 'does not allow the delete action' do
      expect { @item.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end

  describe 'statistics' do
    before :each do
      @item = OneviewSDK::API300::Synergy::Interconnect.new(@client_300, {})
    end

    it 'port' do
      expect(@client_300).to receive(:rest_get).with('/statistics/p1').and_return(FakeResponse.new)
      @item.statistics('p1')
    end

    it 'port and subport' do
      expect(@client_300).to receive(:rest_get).with('/statistics/p1/subport/sp1').and_return(FakeResponse.new)
      @item.statistics('p1', 'sp1')
    end

  end

  describe 'get link' do
    it 'topology' do
      link_topology_list = FakeResponse.new(
        'members' => [
          { 'name' => 'topology_a', 'uri' => 'rest/fake/A' },
          { 'name' => 'topology_b', 'uri' => 'rest/fake/B' },
          { 'name' => 'topology_c', 'uri' => 'rest/fake/C' }
        ]
      )
      expect(@client_300).to receive(:rest_get).with('/rest/interconnect-link-topologies').and_return(link_topology_list)
      @item = OneviewSDK::API300::Synergy::Interconnect.get_link_topology(@client_300, 'topology_c')
      expect(@item['uri']).to eq('rest/fake/C')
    end

  end
end
