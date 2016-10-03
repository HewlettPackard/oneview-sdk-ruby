require 'spec_helper'

RSpec.describe OneviewSDK::API300::Thunderbird::Switch do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::Switch
  end

  describe '#remove' do
    it 'Should support remove' do
      switch = OneviewSDK::API300::Thunderbird::Switch.new(@client_300, uri: '/rest/switches/100')
      expect(@client_300).to receive(:rest_delete).with('/rest/switches/100', {}, 300).and_return(FakeResponse.new({}))
      switch.remove
    end
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

  describe 'statistics' do
    before :each do
      @item = OneviewSDK::API300::Thunderbird::Switch.new(@client_300, {})
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

  describe 'undefined methods' do
    it 'does not allow the create action' do
      switch = OneviewSDK::API300::Thunderbird::Switch.new(@client_300)
      expect { switch.create }.to raise_error(OneviewSDK::MethodUnavailable, /The method #create is unavailable for this resource/)
    end

    it 'does not allow the update action' do
      switch = OneviewSDK::API300::Thunderbird::Switch.new(@client_300)
      expect { switch.update }.to raise_error(OneviewSDK::MethodUnavailable, /The method #update is unavailable for this resource/)
    end

    it 'does not allow the refresh action' do
      switch = OneviewSDK::API300::Thunderbird::Switch.new(@client_300)
      expect { switch.refresh }.to raise_error(OneviewSDK::MethodUnavailable, /The method #refresh is unavailable for this resource/)
    end

    it 'does not allow the delete action' do
      switch = OneviewSDK::API300::Thunderbird::Switch.new(@client_300)
      expect { switch.delete }.to raise_error(OneviewSDK::MethodUnavailable, /The method #delete is unavailable for this resource/)
    end
  end
end
