require 'spec_helper'

klass = OneviewSDK::API300::C7000::Switch
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  before :all do
    @item = klass.find_by($client_300, {}).first
  end

  describe '#statistics' do
    it 'gets data for the port X1' do
      expect(@item.statistics('X1')).to_not be_empty
    end

    it 'gets data for the port X1 with subport Q1' do
      expect(@item.statistics('X1', 'Q1')).to_not be_empty
    end
  end

  describe '#environmentalConfiguration' do
    it 'gets the current environmental configuration' do
      expect(@item.environmental_configuration).to_not be_empty
    end
  end

  describe '#get_types' do
    it 'list all the types' do
      expect(klass.get_types($client_300)).to_not be_empty
    end

    it 'get one desired type' do
      model_name = 'Cisco Nexus 55xx'
      model = klass.get_type($client_300, model_name)
      expect(model).to_not be_empty
      expect(model['name']).to eq(model_name)
      expect(model['uri']).to_not be_empty
    end
  end
end
