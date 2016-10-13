require 'spec_helper'

RSpec.describe OneviewSDK::API300::Thunderbird::LogicalSwitch do
  include_context 'shared context'

  it 'does not inherit from API200 or API300' do
    expect(described_class).not_to be < OneviewSDK::API200::LogicalSwitch
    expect(described_class).not_to be < OneviewSDK::Resource
  end

  describe '#get_internal_link_sets' do
    it 'finds the specified internal link set' do
      internal_link_set_list = FakeResponse.new(
        'members' => [
          { 'name' => 'InternalLinkSet1', 'uri' => 'rest/fake/internal-link-set' },
          { 'name' => 'InternalLinkSet2', 'uri' => 'rest/fake/B' },
          { 'name' => 'InternalLinkSet3', 'uri' => 'rest/fake/C' }
        ]
      )
      expect(@client_300).to receive(:rest_get).with('/rest/internal-link-sets').and_return(internal_link_set_list)
      item = OneviewSDK::API300::Thunderbird::LogicalSwitch.get_internal_link_set(@client_300, 'InternalLinkSet1')
      expect(item['uri']).to eq('rest/fake/internal-link-set')
    end
  end
end
