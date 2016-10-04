require 'spec_helper'

klass = OneviewSDK::LogicalSwitchGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration context'

  before :all do
    @item = OneviewSDK::LogicalSwitchGroup.new($client, name: LOG_SWI_GROUP_NAME)
    @type = 'Cisco Nexus 55xx'
  end

  describe '#create' do
    it 'LSG with unrecognized interconnect' do
      expect { @item.set_grouping_parameters(1, 'invalid_type') }.to raise_error(/Switch type invalid_type/)
    end

    it 'LSG with two switches' do
      @item.set_grouping_parameters(2, @type)
      expect { @item.create }.to_not raise_error
    end
  end

  describe '#retrieve!' do
    it 'retrieves the objects' do
      @item = OneviewSDK::LogicalSwitchGroup.new($client, name: LOG_SWI_GROUP_NAME)
      @item.retrieve!
      expect(@item['uri']).to be
    end
  end

end
