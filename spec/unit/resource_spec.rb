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

    it 'has a base subset of attributes' do
      res = OneviewSDK::Resource.new(@client)
      expect(res.uri).to be_nil
    end

    it 'sets the provided attributes' do
      res = OneviewSDK::Resource.new(@client, name: 'Test', description: 'None')
      expect(res.name).to eq('Test')
      expect(res.description).to eq('None')
    end

    it 'does not allow reserved method names to be used as attribute names' do
      res = nil
      expect { res = OneviewSDK::Resource.new(@client, to_hash: 'Val') }.to output(/that's a reserved method/).to_stdout_from_any_process
      expect(res.to_hash).to_not eq('Val')
    end
  end
end
