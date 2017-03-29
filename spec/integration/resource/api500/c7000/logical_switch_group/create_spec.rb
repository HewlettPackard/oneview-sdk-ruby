require 'spec_helper'

klass = OneviewSDK::API500::C7000::LogicalSwitchGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api500 context'

  let(:type) { 'Cisco Nexus 55xx' }
  subject(:item) { klass.new($client_500, name: LOG_SWI_GROUP_NAME) }

  describe '#create' do
    it 'LSG with unrecognized interconnect' do
      expect { item.set_grouping_parameters(1, 'invalid_type') }.to raise_error(/Switch type invalid_type/)
    end

    it 'LSG with two switches' do
      item.set_grouping_parameters(2, type)
      expect { item.create }.to_not raise_error
    end
  end

  describe '#retrieve!' do
    it 'retrieves the objects' do
      item = klass.new($client_500, name: LOG_SWI_GROUP_NAME)
      item.retrieve!
      expect(item['uri']).to be
    end

    it 'retrieves all the objects' do
      list = klass.find_by($client_500, {})
      expect(list).not_to be_empty
    end
  end
end
