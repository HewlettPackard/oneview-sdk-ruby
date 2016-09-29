require_relative './../spec_helper'

RSpec.describe OneviewSDK::Resource do
  include_context 'shared context'

  describe '#initialize' do
    it 'requires a valid client to be passed' do
      expect { OneviewSDK::Resource.new(nil) }.to raise_error(OneviewSDK::InvalidClient, /Must specify a valid client/)
      expect { OneviewSDK::Resource.new('client') }.to raise_error(OneviewSDK::InvalidClient, /Must specify a valid client/)
    end

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

    it 'can\'t use an api version greater than the client\'s max' do
      expect { OneviewSDK::Resource.new(@client, {}, 400) }.to raise_error(OneviewSDK::UnsupportedVersion, /is greater than the client's max/)
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

  describe '#retrieve!' do
    it 'requires the name attribute to be set' do
      res = OneviewSDK::Resource.new(@client)
      expect { res.retrieve! }.to raise_error(OneviewSDK::IncompleteResource, /Must set resource name/)
    end

    it 'sets the data if the resource is found' do
      res = OneviewSDK::Resource.new(@client, name: 'ResourceName')
      allow(OneviewSDK::Resource).to receive(:find_by).and_return([
        OneviewSDK::Resource.new(@client, res.data.merge(uri: '/rest/fake', description: 'Blah'))
      ])
      res.retrieve!
      expect(res['uri']).to eq('/rest/fake')
      expect(res['description']).to eq('Blah')
    end

    it 'returns false when the resource is not found' do
      allow(OneviewSDK::Resource).to receive(:find_by).and_return([])
      res = OneviewSDK::Resource.new(@client, name: 'ResourceName')
      expect(res.retrieve!).to eq(false)
    end
  end

  describe '#exists?' do
    it 'requires the name attribute to be set' do
      res = OneviewSDK::Resource.new(@client)
      expect { res.exists? }.to raise_error(OneviewSDK::IncompleteResource, /Must set resource name or uri/)
    end

    it 'uses the uri attribute when the name is not set' do
      res = OneviewSDK::Resource.new(@client, uri: '/rest/fake')
      expect(OneviewSDK::Resource).to receive(:find_by).with(@client, uri: res['uri']).and_return([])
      expect(res.exists?).to eq(false)
    end

    it 'returns true when the resource is found' do
      res = OneviewSDK::Resource.new(@client, name: 'ResourceName')
      expect(OneviewSDK::Resource).to receive(:find_by).with(@client, name: res['name']).and_return([res])
      expect(res.exists?).to eq(true)
    end

    it 'returns false when the resource is not found' do
      res = OneviewSDK::Resource.new(@client, uri: '/rest/fake')
      expect(OneviewSDK::Resource).to receive(:find_by).with(@client, uri: res['uri']).and_return([])
      expect(res.exists?).to eq(false)
    end
  end

  describe '#==' do
    context 'class equality' do
      it 'returns true when the classes are the same' do
        res1 = OneviewSDK::Enclosure.new(@client, name: 'ResourceName')
        res2 = OneviewSDK::Enclosure.new(@client, name: 'ResourceName')
        expect(res1 == res2).to eq(true)
      end

      it 'returns false when the classes are not the same' do
        res1 = OneviewSDK::Resource.new(@client, name: 'ResourceName')
        res2 = OneviewSDK::Enclosure.new(@client, name: 'ResourceName')
        expect(res1 == res2).to eq(false)
      end
    end

    context 'attribute equality' do
      it 'returns true when the attributes are the same' do
        res1 = OneviewSDK::Enclosure.new(@client, name: 'ResourceName')
        res2 = OneviewSDK::Enclosure.new(@client, name: 'ResourceName')
        expect(res1 == res2).to eq(true)
      end

      it 'returns false when the attributes are not the same' do
        res1 = OneviewSDK::Enclosure.new(@client)
        res2 = OneviewSDK::Enclosure.new(@client, name: 'ResourceName')
        expect(res1 == res2).to eq(false)
      end
    end
  end

  describe '#eql?' do
    it 'calls the == method' do
      res1 = OneviewSDK::Enclosure.new(@client, name: 'ResourceName')
      res2 = OneviewSDK::Enclosure.new(@client, name: 'ResourceName')
      expect(res1).to receive(:==).with(res2)
      res1.eql?(res2)
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

  describe '#create' do
    it 'requires the client to be set' do
      res = OneviewSDK::Resource.new(@client)
      res.client = nil
      expect { res.create }.to raise_error(OneviewSDK::IncompleteResource, /Please set client attribute/)
    end

    it 'sets the data from the response' do
      res = OneviewSDK::Resource.new(@client, name: 'Name')
      fake_response = FakeResponse.new(res.data.merge(uri: '/rest/fake'))
      allow(@client).to receive(:rest_post).and_return(fake_response)
      res.create
      expect(res['uri']).to eq('/rest/fake')
    end

    it 'raises an error if the request failed' do
      res = OneviewSDK::Resource.new(@client, name: 'Name')
      fake_response = FakeResponse.new({ message: 'Invalid' }, 400)
      allow(@client).to receive(:rest_post).and_return(fake_response)
      expect { res.create }.to raise_error(OneviewSDK::BadRequest, /400 BAD REQUEST {"message":"Invalid"}/)
    end
  end

  describe '#create!' do
    before :each do
      @res = OneviewSDK::Resource.new(@client, name: 'Name')
    end

    it 'deletes the resource if it exists' do
      allow_any_instance_of(@res.class).to receive(:retrieve!).and_return(true)
      expect_any_instance_of(@res.class).to receive(:delete).and_return(true)
      expect(@res).to receive(:create)
      @res.create!
    end

    it 'does not delete the resource if it does not exist' do
      allow_any_instance_of(@res.class).to receive(:retrieve!).and_return(false)
      expect_any_instance_of(@res.class).not_to receive(:delete)
      expect(@res).to receive(:create)
      @res.create!
    end
  end

  describe '#refresh' do
    it 'requires the client to be set' do
      res = OneviewSDK::Resource.new(@client)
      res.client = nil
      expect { res.refresh }.to raise_error(OneviewSDK::IncompleteResource, /Please set client attribute/)
    end

    it 'requires the uri to be set' do
      res = OneviewSDK::Resource.new(@client)
      expect { res.refresh }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'sets the data from the server\'s response' do
      res = OneviewSDK::Resource.new(@client, name: 'Name', uri: '/rest/fake')
      fake_response = FakeResponse.new(res.data.merge(name: 'NewName', description: 'Blah'))
      allow(@client).to receive(:rest_get).and_return(fake_response)
      res.refresh
      expect(res['name']).to eq('NewName')
      expect(res['description']).to eq('Blah')
    end
  end

  describe '#update' do
    it 'requires the client to be set' do
      res = OneviewSDK::Resource.new(@client)
      res.client = nil
      expect { res.update }.to raise_error(OneviewSDK::IncompleteResource, /Please set client attribute/)
    end

    it 'requires the uri to be set' do
      res = OneviewSDK::Resource.new(@client)
      expect { res.update }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'uses the rest_put method to update the data' do
      res = OneviewSDK::Resource.new(@client, name: 'Name', uri: '/rest/fake')
      expect(@client).to receive(:rest_put).with(res['uri'], { 'body' => res.data }, res.api_version).and_return(FakeResponse.new)
      res.update
    end

    it 'raises an error if the update fails' do
      res = OneviewSDK::Resource.new(@client, name: 'Name', uri: '/rest/fake')
      fake_response = FakeResponse.new({ message: 'Invalid' }, 400)
      expect(@client).to receive(:rest_put).with(res['uri'], { 'body' => res.data }, res.api_version).and_return(fake_response)
      expect { res.update }.to raise_error(OneviewSDK::BadRequest, /400 BAD REQUEST {"message":"Invalid"}/)
    end
  end

  describe '#delete' do
    it 'requires the client to be set' do
      res = OneviewSDK::Resource.new(@client)
      res.client = nil
      expect { res.delete }.to raise_error(OneviewSDK::IncompleteResource, /Please set client attribute/)
    end

    it 'requires the uri to be set' do
      res = OneviewSDK::Resource.new(@client)
      expect { res.delete }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'returns true if the delete was successful' do
      res = OneviewSDK::Resource.new(@client, name: 'Name', uri: '/rest/fake')
      expect(@client).to receive(:rest_delete).with(res['uri'], {}, res.api_version).and_return(FakeResponse.new)
      expect(res.delete).to eq(true)
    end

    it 'raises an error if the delete fails' do
      res = OneviewSDK::Resource.new(@client, name: 'Name', uri: '/rest/fake')
      fake_response = FakeResponse.new({ message: 'Invalid' }, 400)
      expect(@client).to receive(:rest_delete).with(res['uri'], {}, res.api_version).and_return(fake_response)
      expect { res.delete }.to raise_error(OneviewSDK::BadRequest, /400 BAD REQUEST {"message":"Invalid"}/)
    end
  end

  describe '#to_file' do
    let(:file_like_object) { double('file like object') }

    before :each do
      @res = OneviewSDK::Enclosure.new(@client, name: 'Name', uri: '/rest/fake')
      @data = { type: @res.class.name, api_version: @res.api_version, data: @res.data }
    end

    it 'writes files in json format by default' do
      path = 'res'
      expect(File).to receive(:open).with(path, 'w').and_yield(file_like_object)
      expect(file_like_object).to receive(:write).with(JSON.pretty_generate(@data))
      @res.to_file(path)
    end

    it 'writes files in yml format' do
      path = 'res.yml'
      expect(File).to receive(:open).with(path, 'w').and_yield(file_like_object)
      expect(file_like_object).to receive(:write).with(@data.to_yaml)
      @res.to_file(path)
    end

    it 'fails when an invalid format is specified' do
      path = 'res.txt'
      expect { @res.to_file(path, 'txt') }.to raise_error(OneviewSDK::InvalidFormat, /Invalid format/)
    end
  end

  describe '#schema' do
    it 'forwards the instance method call to the class method' do
      expect(OneviewSDK::Resource).to receive(:schema).with(@client)
      OneviewSDK::Resource.new(@client).schema
    end

    it 'tries to get BASE_URI/schema' do
      expect(@client).to receive(:rest_get).with("#{OneviewSDK::Resource::BASE_URI}/schema", @client.api_version)
        .and_return(FakeResponse.new(key: 'val1', other_key: 'val2'))
      schema = OneviewSDK::Resource.schema(@client)
      expect(schema['key']).to eq('val1')
      expect(schema['other_key']).to eq('val2')
    end

    it 'displays a nice error if the schema endpoint returns a 404 response' do
      fake_response = FakeResponse.new({ message: 'Not Found' }, 404)
      allow(@client).to receive(:rest_get).and_return(fake_response)
      expect(@client.logger).to receive(:error).with(/does not implement the schema endpoint/)
      expect { OneviewSDK::Resource.schema(@client) }.to raise_error(OneviewSDK::NotFound, /404 NOT FOUND/)
    end
  end

  describe '#find_by' do
    it 'returns an empty array if no results are found' do
      fake_response = FakeResponse.new(members: [])
      allow(@client).to receive(:rest_get).and_return(fake_response)
      res = OneviewSDK::Enclosure.find_by(@client, {})
      expect(res.size).to eq(0)
    end

    it 'returns an array of resources if results are found' do
      fake_response = FakeResponse.new(members: [
        { name: 'Enc1', uri: "#{OneviewSDK::Enclosure::BASE_URI}/1", state: 'Monitored' },
        { name: 'Enc2', uri: "#{OneviewSDK::Enclosure::BASE_URI}/2", state: 'Adding' },
        { name: 'Enc3', uri: "#{OneviewSDK::Enclosure::BASE_URI}/3", state: 'Monitored' },
        { name: 'Enc4', uri: "#{OneviewSDK::Enclosure::BASE_URI}/4" }
      ])
      allow(@client).to receive(:rest_get).and_return(fake_response)
      res = OneviewSDK::Enclosure.find_by(@client, state: 'Monitored')
      expect(res.size).to eq(2)
      res.each do |r|
        expect(r.class).to eq(OneviewSDK::Enclosure)
        expect(r['state']).to eq('Monitored')
      end
    end
  end

  describe '#get_all' do
    it 'calls find_by with an empty attributes hash' do
      expect(OneviewSDK::Resource).to receive(:find_by).with(@client, {})
      OneviewSDK::Resource.get_all(@client)
    end
  end

  describe '#build_query' do
    it 'builds basic query' do
      expect(OneviewSDK::Resource.build_query('test' => 'TEST')).to eq('?test=TEST')
    end

    it 'builds resource query' do
      fake_resource = OneviewSDK::Resource.new(@client, 'uri' => 'URI')
      expect(OneviewSDK::Resource.build_query('this_resource' => fake_resource)).to eq('?thisResourceUri=URI')
    end

    it 'builds composed query' do
      fake_resource = OneviewSDK::Resource.new(@client, 'uri' => 'URI')
      expect(OneviewSDK::Resource.build_query('test' => 'TEST', 'this_resource' => fake_resource)).to eq('?test=TEST&thisResourceUri=URI')
    end

    it 'returns empty String for invalid values' do
      expect(OneviewSDK::Resource.build_query('')).to eq('')
      expect(OneviewSDK::Resource.build_query(nil)).to eq('')
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

    it 'ignores dashes, underscores & spaces' do
      expect(OneviewSDK.resource_named('se rver-prof_ile')).to eq(OneviewSDK::ServerProfile)
    end

    it 'supports symbols' do
      expect(OneviewSDK.resource_named(:server_profile)).to eq(OneviewSDK::ServerProfile)
    end
  end
end
