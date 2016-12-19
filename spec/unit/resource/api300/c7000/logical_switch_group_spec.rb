require 'spec_helper'

klass = OneviewSDK::API300::C7000::LogicalSwitchGroup
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::LogicalSwitchGroup
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = klass.new(@client_300)
      expect(item['category']).to eq('logical-switch-groups')
      expect(item['state']).to eq('Active')
      expect(item['type']).to eq('logical-switch-groupV300')
      expect(item['switchMapTemplate']).to be
    end
  end

  describe '#set_grouping_parameters' do
    before :each do
      @item = klass.new(@client_300)
      @type = 'Cisco Nexus 55xx'
    end

    it 'defines a valid switch group' do
      expect(OneviewSDK::Switch).to receive(:get_type).with(@client_300, @type)
        .and_return('uri' => '/rest/fake')
      @item.set_grouping_parameters(1, @type)
      expect(@item['switchMapTemplate']['switchMapEntryTemplates'].first['permittedSwitchTypeUri'])
        .to eq('/rest/fake')
    end

    it 'raises an error if the switch is not found' do
      expect(OneviewSDK::Switch).to receive(:get_type).with(@client_300, @type)
        .and_return([])
      expect(OneviewSDK::Switch).to receive(:get_types).and_return([{ 'name' => '1' }, { 'name' => '2' }])
      expect { @item.set_grouping_parameters(1, @type) }.to raise_error(/not found!/)
    end
  end

end
