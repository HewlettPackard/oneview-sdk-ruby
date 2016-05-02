
RSpec.describe OneviewSDK::EnclosureGroup do
  include_context 'shared context'

  describe '#create' do
    it 'cannot be created' do
      @item = OneviewSDK::Switch.new(@client)
      expect { @item.create }.to raise_error(/unavailable for this resource/)
    end
  end

  describe '#update' do
    it 'cannot be updated' do
      @item = OneviewSDK::Switch.new(@client)
      expect { @item.update }.to raise_error(/unavailable for this resource/)
    end
  end

  describe '#get_type' do
    it 'finds the specified switch' do
      switch_type_list = FakeResponse.new(
        'members' => [
          {'name' => 'SwitchA', 'uri' => 'rest/fake/A'},
          {'name' => 'TheSwitch', 'uri' => 'rest/fake/switch'},
          {'name' => 'SwitchC', 'uri' => 'rest/fake/C'}
        ]
      )
      expect(@client).to receive(:rest_get).with('/rest/switch-types').and_return(switch_type_list)
      @item = OneviewSDK::Switch.get_type(@client, 'TheSwitch')
      expect( @item['uri'] ).to eq('rest/fake/switch')
    end
  end

  describe 'statistics' do
    before :each do
      @item = OneviewSDK::Switch.new(@client, {})
    end

    it 'port' do
      expect(@client).to receive(:rest_get).with('/statistics/p1').and_return(FakeResponse.new)
      @item.statistics('p1')
    end

    it 'port and subport' do
      expect(@client).to receive(:rest_get).with('/statistics/p1/subport/sp1').and_return(FakeResponse.new)
      @item.statistics('p1', 'sp1')
    end

  end

end
