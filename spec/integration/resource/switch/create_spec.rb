require 'spec_helper'

RSpec.describe OneviewSDK::Switch, integration: true, type: CREATE, sequence: 15 do
  include_context 'integration context'

  before :all do
    @item = OneviewSDK::Switch.find_by($client, {}).first
  end

  describe 'Unavailable methods' do
    it '#create' do
      expect { @item.create }.to raise_error(/unavailable for this resource/)
    end

    it '#update' do
      expect { @item.update }.to raise_error(/unavailable for this resource/)
    end

    it '#refresh' do
      expect { @item.refresh }.to raise_error(/unavailable for this resource/)
    end
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
      expect(OneviewSDK::Switch.get_types($client)).to_not be_empty
    end

    it 'get one desired type' do
      model_name = 'Cisco Nexus 55xx'
      model = OneviewSDK::Switch.get_type($client, model_name)
      expect(model).to_not be_empty
      expect(model['name']).to eq(model_name)
      expect(model['uri']).to_not be_empty
    end
  end

end
