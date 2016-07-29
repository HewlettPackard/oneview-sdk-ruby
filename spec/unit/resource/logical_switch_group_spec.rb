require 'spec_helper'

RSpec.describe OneviewSDK::LogicalSwitchGroup do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::LogicalSwitchGroup.new(@client)
      expect(item['category']).to eq('logical-switch-groups')
      expect(item['state']).to eq('Active')
      expect(item['type']).to eq('logical-switch-group')
      expect(item['switchMapTemplate']).to be
    end
  end

  describe '#set_grouping_parameters' do
    before :each do
      @item = OneviewSDK::LogicalSwitchGroup.new(@client)
      @type = 'Cisco Nexus 55xx'
    end

    it 'defines a valid siwtch group' do
      expect(OneviewSDK::Switch).to receive(:get_type).with(@client, @type)
        .and_return('uri' => '/rest/fake')
      @item.set_grouping_parameters(1, @type)
      expect(@item['switchMapTemplate']['switchMapEntryTemplates'].first['permittedSwitchTypeUri'])
        .to eq('/rest/fake')
    end

    it 'raises an error if the switch is not found' do
      expect(OneviewSDK::Switch).to receive(:get_type).with(@client, @type)
        .and_return([])
      expect(OneviewSDK::Switch).to receive(:get_types).and_return([{ 'name' => '1' }, { 'name' => '2' }])
      expect { @item.set_grouping_parameters(1, @type) }.to raise_error(/not found!/)
    end
  end

end
