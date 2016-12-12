require 'spec_helper'

klass = OneviewSDK::API300::C7000::Switch
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  describe '#get_types' do
    it 'list all the types' do
      expect(klass.get_types($client_300_synergy)).to_not be_empty
    end

    it 'get one desired type' do
      model_name = 'Cisco Nexus 55xx'
      model = klass.get_type($client_300_synergy, model_name)
      expect(model).to_not be_empty
      expect(model['name']).to eq(model_name)
      expect(model['uri']).to_not be_empty
    end
  end
end
