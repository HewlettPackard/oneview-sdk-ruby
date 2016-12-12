require 'spec_helper'

klass = OneviewSDK::API300::Synergy::LogicalSwitchGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  before :all do
    @item = klass.new($client_300_synergy, name: LOG_SWI_GROUP_NAME)
    @type = 'Cisco Nexus 55xx'
  end

  describe '#create' do
    it 'self raises MethodUnavailable' do
      expect { @item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe '#set_grouping_parameters' do
    it 'self raises MethodUnavailable' do
      expect { @item.set_grouping_parameters }.to raise_error(/The method #set_grouping_parameters is unavailable for this resource/)
    end
  end
end
