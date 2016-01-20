require_relative './../spec_helper'

RSpec.describe OneviewSDK::Resource do
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

    it 'allows setting the base_uri for undefined classes' do
      base_uri = '/rest/my-resource'
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: "#{base_uri}/1")
      res = OneviewSDK::Resource.new(@client)
      res.base_uri = base_uri
      expect(@client).to receive(:rest_post).with(base_uri, { 'body' => res.data }, res.api_version)
      res.create
      expect(res[:uri]).to eq("#{base_uri}/1")
    end
  end

  describe '#like?' do
    it 'returns true for an alike hash' do
      options = { name: 'res', uri: '/rest/fake', description: 'Resource' }
      res = OneviewSDK::Resource.new(@client, options)
      expect(res.like?(description: 'Resource', uri: '/rest/fake', name: 'res')).to eq(true)
    end

    it 'returns true for an alike resource' do
      options = { name: 'res', uri: '/rest/fake', description: 'Resource' }
      res = OneviewSDK::Resource.new(@client, options)
      res2 = OneviewSDK::Resource.new(@client, options)
      expect(res.like?(res2)).to eq(true)
    end

    it 'does not compare client object or api_version' do
      options = { name: 'res', uri: '/rest/fake', description: 'Resource' }
      res = OneviewSDK::Resource.new(@client, options)
      res2 = OneviewSDK::Resource.new(@client_120, options, 120)
      expect(res.like?(res2)).to eq(true)
    end

    it 'works for nested hashes' do
      options = { name: 'res', uri: '/rest/fake', data: { 'key1' => 'val1', 'key2' => 'val2' } }
      res = OneviewSDK::Resource.new(@client, options)
      expect(res.like?(data: { key2: 'val2' })).to eq(true)
    end

    it 'returns false for unlike hashes' do
      options = { name: 'res', uri: '/rest/fake' }
      res = OneviewSDK::Resource.new(@client, options)
      expect(res.like?(data: { key2: 'val2' })).to eq(false)
    end

    it 'requires the other objet to respond to .each' do
      res = OneviewSDK::Resource.new(@client)
      expect { res.like?(nil) }.to raise_error(/Can't compare with object type: NilClass/)
    end
  end

  describe '#get_all' do
    it 'calls find_by with an empty attributes hash' do
      expect(OneviewSDK::Resource).to receive(:find_by).with(@client, {})
      OneviewSDK::Resource.get_all(@client)
    end
  end
end

RSpec.describe OneviewSDK do
  describe '#resource_named' do
    it 'gets the correct resource class' do
      expect(OneviewSDK.resource_named('ServerProfile')).to eq(OneviewSDK::ServerProfile)
      expect(OneviewSDK.resource_named('FCoENetwork')).to eq(OneviewSDK::FCoENetwork)
    end

    it 'ignores case' do
      expect(OneviewSDK.resource_named('SERVERProfilE')).to eq(OneviewSDK::ServerProfile)
    end

    it 'ignores dashes and underscores' do
      expect(OneviewSDK.resource_named('server-prof_ile')).to eq(OneviewSDK::ServerProfile)
    end

    it 'supports symbols' do
      expect(OneviewSDK.resource_named(:server_profile)).to eq(OneviewSDK::ServerProfile)
    end
  end
end
