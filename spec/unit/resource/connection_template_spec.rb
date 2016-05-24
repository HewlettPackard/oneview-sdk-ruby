require 'spec_helper'

RSpec.describe OneviewSDK::ConnectionTemplate do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      connection = OneviewSDK::ConnectionTemplate.new(@client)
      expect(connection['bandwidth']).to eq({})
      expect(connection['type']).to eq('connection-template')
    end

    it 'sets maximum and typical bandwidth' do
      connection = OneviewSDK::ConnectionTemplate.new(@client)
      connection['bandwidth']['maximumBandwidth'] = 1000
      connection['bandwidth']['typicalBandwidth'] = 5000
      expect(connection['bandwidth']['maximumBandwidth']).to eq(1000)
      expect(connection['bandwidth']['typicalBandwidth']).to eq(5000)
    end
  end

  describe '#get_default' do
    it 'verify endpoint' do
      expect(@client).to receive(:rest_get).with('/rest/connection-templates/defaultConnectionTemplate').and_return(FakeResponse.new({}))
      OneviewSDK::ConnectionTemplate.get_default(@client)
    end
  end

  describe '#create' do
    it 'is unavailable' do
      connection = OneviewSDK::ConnectionTemplate.new(@client)
      expect { connection.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe '#delete' do
    it 'is unavailable' do
      connection = OneviewSDK::ConnectionTemplate.new(@client)
      expect { connection.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end

end
