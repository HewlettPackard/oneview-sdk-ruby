require_relative './../spec_helper'

RSpec.describe OneviewSDK::Client do
  include_context 'shared context'

  describe '#initialize' do
    it 'uses the client\'s logger' do
      res = OneviewSDK::Resource.new(@client)
      expect(res.logger).to eq(@client.logger)
    end

    it 'uses the client\'s api version' do
      res = OneviewSDK::Resource.new(@client)
      expect(res.api_version).to eq(@client.api_version)
    end

    it 'can override the client\'s api version' do
      res = OneviewSDK::Resource.new(@client, {}, 120)
      expect(res.api_version).to_not eq(@client.api_version)
      expect(res.api_version).to eq(120)
    end

    it 'starts with an empty data hash' do
      res = OneviewSDK::Resource.new(@client)
      expect(res.data).to eq({})
    end

    it 'sets the provided attributes' do
      res = OneviewSDK::Resource.new(@client, name: 'Test', description: 'None')
      expect(res[:name]).to eq('Test')
      expect(res['description']).to eq('None')
    end
  end
end
