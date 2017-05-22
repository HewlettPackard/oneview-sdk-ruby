require 'spec_helper'

RSpec.describe OneviewSDK::API500::C7000::Interconnect do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::C7000::Interconnect' do
    expect(described_class).to be < OneviewSDK::API300::C7000::Interconnect
  end

  describe '#get_pluggable_module_information' do
    it 'when called and interconnect without URI' do
      item = described_class.new(@client_500)
      expect { item.get_pluggable_module_information }.to raise_error(/Please set uri attribute before interacting with this resource/)
    end

    it 'Gets pluggable module information' do
      item = described_class.new(@client_500, uri: 'rest/fake')
      fake_response = FakeResponse.new
      expect(@client_500).to receive(:rest_get).with('rest/fake/pluggableModuleInformation').and_return(fake_response)
      expect(@client_500).to receive(:response_handler).with(fake_response).and_return('fake')
      expect(item.get_pluggable_module_information).to eq('fake')
    end
  end
end
