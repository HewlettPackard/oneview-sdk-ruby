require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::Switch do
  include_context 'shared context'

  it 'does not inherit from API200' do
    expect(described_class).not_to be < OneviewSDK::API200::Switch
    expect(described_class).not_to be < OneviewSDK::Resource
  end

  describe '#get_type' do
    it 'finds the specified switch' do
      switch_type_list = FakeResponse.new(
        'members' => [
          { 'name' => 'SwitchA', 'uri' => 'rest/fake/A' },
          { 'name' => 'TheSwitch', 'uri' => 'rest/fake/switch' },
          { 'name' => 'SwitchC', 'uri' => 'rest/fake/C' }
        ]
      )
      expect(@client_300).to receive(:rest_get).with('/rest/switch-types').and_return(switch_type_list)
      @item = described_class.get_type(@client_300, 'TheSwitch')
      expect(@item['uri']).to eq('rest/fake/switch')
    end
  end

  describe '#get_types' do
    it 'finds the specified switch' do
      expect(@client_300).to receive(:rest_get).with('/rest/switch-types').and_return(FakeResponse.new('members' => []))
      expect(described_class.get_types(@client_300)).to be
    end
  end
end
