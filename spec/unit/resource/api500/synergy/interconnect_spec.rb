require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::Interconnect do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::C7000::Interconnect' do
    expect(described_class).to be < OneviewSDK::API500::C7000::Interconnect
  end

  describe '#get_link_topologies' do
    it 'Gets all topologies' do
      topologies = [
        { 'name' => 'topology_a', 'uri' => 'rest/fake/A' },
        { 'name' => 'topology_b', 'uri' => 'rest/fake/B' },
        { 'name' => 'topology_c', 'uri' => 'rest/fake/C' }
      ]
      link_topology_list = FakeResponse.new('members' => topologies)

      expect(@client_500).to receive(:rest_get).with('/rest/interconnect-link-topologies').and_return(link_topology_list)
      result = OneviewSDK::API500::Synergy::Interconnect.get_link_topologies(@client_500)
      expect(result).to eq(topologies)
    end
  end

  describe '#get_link_topology' do
    it 'Gets topology by name' do
      link_topology_list = FakeResponse.new(
        'members' => [
          { 'name' => 'topology_a', 'uri' => 'rest/fake/A' },
          { 'name' => 'topology_b', 'uri' => 'rest/fake/B' },
          { 'name' => 'topology_c', 'uri' => 'rest/fake/C' }
        ]
      )
      expect(@client_500).to receive(:rest_get).with('/rest/interconnect-link-topologies').and_return(link_topology_list)
      topology = OneviewSDK::API500::Synergy::Interconnect.get_link_topology(@client_500, 'topology_c')
      expect(topology['uri']).to eq('rest/fake/C')
    end
  end
end
