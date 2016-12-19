require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::ConnectionTemplate do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::ConnectionTemplate
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      connection = OneviewSDK::API300::C7000::ConnectionTemplate.new(@client_300)
      expect(connection['bandwidth']).to eq({})
      expect(connection['type']).to eq('connection-template')
    end

    it 'sets maximum and typical bandwidth' do
      connection = OneviewSDK::API300::C7000::ConnectionTemplate.new(@client_300)
      connection['bandwidth']['maximumBandwidth'] = 1000
      connection['bandwidth']['typicalBandwidth'] = 5000
      expect(connection['bandwidth']['maximumBandwidth']).to eq(1000)
      expect(connection['bandwidth']['typicalBandwidth']).to eq(5000)
    end
  end

  describe '#get_default' do
    it 'verify endpoint' do
      expect(@client_300).to receive(:rest_get).with('/rest/connection-templates/defaultConnectionTemplate').and_return(FakeResponse.new({}))
      connection = OneviewSDK::API300::C7000::ConnectionTemplate.get_default(@client_300)
      expect(connection).to be_an_instance_of OneviewSDK::API300::C7000::ConnectionTemplate
    end
  end

  describe '#create' do
    it 'is unavailable' do
      connection = OneviewSDK::API300::C7000::ConnectionTemplate.new(@client_300)
      expect { connection.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe '#delete' do
    it 'is unavailable' do
      connection = OneviewSDK::API300::C7000::ConnectionTemplate.new(@client_300)
      expect { connection.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end
end
