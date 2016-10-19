require 'spec_helper'

RSpec.describe OneviewSDK::API300::Thunderbird::Switch do
  include_context 'shared context'

  it 'does not inherit from API200' do
    expect(described_class).not_to be < OneviewSDK::API200::Switch
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
      @item = OneviewSDK::API300::Thunderbird::Switch.get_type(@client_300, 'TheSwitch')
      expect(@item['uri']).to eq('rest/fake/switch')
    end
  end
end
