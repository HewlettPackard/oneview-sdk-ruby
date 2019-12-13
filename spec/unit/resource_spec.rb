require_relative './../spec_helper'

RSpec.describe OneviewSDK::Resource do
  include_context 'shared context'

  describe 'default constants' do
    it 'should there is default request header as a empty hash' do
      expect(described_class::DEFAULT_REQUEST_HEADER).to eq({})
    end

    it 'should there is unique identifiers with name and uri' do
      expect(described_class::UNIQUE_IDENTIFIERS).to eq(%w[name uri])
    end
  end

  describe '#initialize' do
    it 'requires a valid client to be passed' do
      expect { OneviewSDK::Resource.new(nil) }.to raise_error(OneviewSDK::InvalidClient, /Must specify a valid client/)
      expect { OneviewSDK::Resource.new('client') }.to raise_error(OneviewSDK::InvalidClient, /Must specify a valid client/)
    end

    it 'uses the client\'s logger' do
      res = OneviewSDK::Resource.new(@client_200)
      expect(res.logger).to eq(@client_200.logger)
    end

    it 'uses the client\'s api version' do
      res = OneviewSDK::Resource.new(@client_200)
      expect(res.api_version).to eq(@client_200.api_version)
    end

    it 'can override the client\'s api version' do
      res = OneviewSDK::Resource.new(@client_200, {}, 120)
      expect(res.api_version).to_not eq(@client_200.api_version)
      expect(res.api_version).to eq(120)
    end

    it 'can\'t use an api version greater than the client\'s max' do
      expect { OneviewSDK::Resource.new(@client_200, {}, 1400) }.to raise_error(OneviewSDK::UnsupportedVersion, /is greater than the client's max/)
    end

    it 'starts with an empty data hash' do
      res = OneviewSDK::Resource.new(@client_200)
      expect(res.data).to eq({})
    end

    it 'sets the provided attributes' do
      res = OneviewSDK::Resource.new(@client_200, name: 'Test', description: 'None')
      expect(res[:name]).to eq('Test')
      expect(res['description']).to eq('None')
    end
  end

  describe '#retrieve!' do
    it 'should have the default parameter header' do
      res = described_class.new(@client_200, name: 'ResourceName')
      expect(described_class).to receive(:find_by)
        .with(@client_200, { 'name' => 'ResourceName' }, described_class::BASE_URI, {}).and_return([])
      res.retrieve!
    end

    it 'it can override the default parameter header' do
      res = described_class.new(@client_200, name: 'ResourceName')
      expect(described_class).to receive(:find_by)
        .with(@client_200, { 'name' => 'ResourceName' }, described_class::BASE_URI, some_header: 'some_value').and_return([])
      res.retrieve!(some_header: 'some_value')
    end

    it 'requires the name attribute to be set' do
      res = OneviewSDK::Resource.new(@client_200)
      expect { res.retrieve! }.to raise_error(OneviewSDK::IncompleteResource, /Must set resource name/)
    end

    it 'sets the data if the resource is found' do
      res = OneviewSDK::Resource.new(@client_200, name: 'ResourceName')
      allow(OneviewSDK::Resource).to receive(:find_by).and_return([
        OneviewSDK::Resource.new(@client_200, res.data.merge(uri: '/rest/fake', description: 'Blah'))
      ])
      res.retrieve!
      expect(res['uri']).to eq('/rest/fake')
      expect(res['description']).to eq('Blah')
    end

    it 'returns false when the resource is not found' do
      allow(OneviewSDK::Resource).to receive(:find_by).and_return([])
      res = OneviewSDK::Resource.new(@client_200, name: 'ResourceName')
      expect(res.retrieve!).to eq(false)
    end

    it 'returns false when multiple resources match' do
      allow(OneviewSDK::Resource).to receive(:find_by).and_return([
        OneviewSDK::Resource.new(@client_200, name: 'ResourceName'),
        OneviewSDK::Resource.new(@client_200, name: 'ResourceName')
      ])
      res = OneviewSDK::Resource.new(@client_200, name: 'ResourceName')
      expect(res.retrieve!).to eq(false)
    end
  end

  describe '#exists?' do
    it 'should have the default parameter header' do
      res = OneviewSDK::Resource.new(@client_200, uri: '/rest/fake')
      expect(OneviewSDK::Resource).to receive(:find_by)
        .with(@client_200, { 'uri' => res['uri'] }, described_class::BASE_URI, {}).and_return([])
      res.exists?
    end

    it 'it can override the default parameter header' do
      res = OneviewSDK::Resource.new(@client_200, uri: '/rest/fake')
      expect(OneviewSDK::Resource).to receive(:find_by)
        .with(@client_200, { 'uri' => res['uri'] }, described_class::BASE_URI, some_header: 'some_value').and_return([])
      res.exists?(some_header: 'some_value')
    end

    it 'requires the name attribute to be set' do
      res = OneviewSDK::Resource.new(@client_200)
      expect { res.exists? }.to raise_error(OneviewSDK::IncompleteResource, /Must set resource name or uri/)
    end

    it 'uses the uri attribute when the name is not set' do
      res = OneviewSDK::Resource.new(@client_200, uri: '/rest/fake')
      expect(OneviewSDK::Resource).to receive(:find_by)
        .with(@client_200, { 'uri' => res['uri'] }, described_class::BASE_URI, {}).and_return([])
      expect(res.exists?).to eq(false)
    end

    it 'returns true when the resource is found' do
      res = OneviewSDK::Resource.new(@client_200, name: 'ResourceName')
      expect(OneviewSDK::Resource).to receive(:find_by)
        .with(@client_200, { 'name' => res['name'] }, described_class::BASE_URI, {}).and_return([res])
      expect(res.exists?).to eq(true)
    end

    it 'returns false when the resource is not found' do
      res = OneviewSDK::Resource.new(@client_200, uri: '/rest/fake')
      expect(OneviewSDK::Resource).to receive(:find_by)
        .with(@client_200, { 'uri' => res['uri'] }, described_class::BASE_URI, {}).and_return([])
      expect(res.exists?).to eq(false)
    end
  end

  describe '#==' do
    context 'class equality' do
      it 'returns true when the classes are the same' do
        res1 = OneviewSDK::Enclosure.new(@client_200, name: 'ResourceName')
        res2 = OneviewSDK::Enclosure.new(@client_200, name: 'ResourceName')
        expect(res1 == res2).to eq(true)
      end

      it 'returns false when the classes are not the same' do
        res1 = OneviewSDK::Resource.new(@client_200, name: 'ResourceName')
        res2 = OneviewSDK::Enclosure.new(@client_200, name: 'ResourceName')
        expect(res1 == res2).to eq(false)
      end
    end

    context 'attribute equality' do
      it 'returns true when the attributes are the same' do
        res1 = OneviewSDK::Enclosure.new(@client_200, name: 'ResourceName')
        res2 = OneviewSDK::Enclosure.new(@client_200, name: 'ResourceName')
        expect(res1 == res2).to eq(true)
      end

      it 'returns false when the attributes are not the same' do
        res1 = OneviewSDK::Enclosure.new(@client_200)
        res2 = OneviewSDK::Enclosure.new(@client_200, name: 'ResourceName')
        expect(res1 == res2).to eq(false)
      end
    end
  end

  describe '#eql?' do
    it 'calls the == method' do
      res1 = OneviewSDK::Enclosure.new(@client_200, name: 'ResourceName')
      res2 = OneviewSDK::Enclosure.new(@client_200, name: 'ResourceName')
      expect(res1).to receive(:==).with(res2)
      res1.eql?(res2)
    end
  end

  describe '#like?' do
    it 'returns true for an alike hash' do
      options = { name: 'res', uri: '/rest/fake', description: 'Resource' }
      res = OneviewSDK::Resource.new(@client_200, options)
      expect(res.like?(description: 'Resource', uri: '/rest/fake', name: 'res')).to eq(true)
    end

    it 'returns true for an alike resource' do
      options = { name: 'res', uri: '/rest/fake', description: 'Resource' }
      res = OneviewSDK::Resource.new(@client_200, options)
      res2 = OneviewSDK::Resource.new(@client_200, options)
      expect(res.like?(res2)).to eq(true)
    end

    it 'does not compare client object or api_version' do
      options = { name: 'res', uri: '/rest/fake', description: 'Resource' }
      res = OneviewSDK::Resource.new(@client_200, options)
      res2 = OneviewSDK::Resource.new(@client_120, options, 120)
      expect(res.like?(res2)).to eq(true)
    end

    it 'works for nested hashes' do
      options = { name: 'res', uri: '/rest/fake', data: { 'key1' => 1, 'key2' => 'val2', 'key3' => '2' } }
      res = OneviewSDK::Resource.new(@client_200, options)
      expect(res.like?(data: { key1: '1' })).to eq(true)
      expect(res.like?(data: { key1: 1 })).to eq(true)
      expect(res.like?(data: { key2: 'val2' })).to eq(true)
      expect(res.like?(data: { key3: 2 })).to eq(true)
    end

    it 'returns false for unlike hashes' do
      options = { name: 'res', uri: '/rest/fake' }
      res = OneviewSDK::Resource.new(@client_200, options)
      expect(res.like?(data: { key2: 'val2' })).to eq(false)
    end

    it 'requires the other object to respond to .each' do
      res = OneviewSDK::Resource.new(@client_200)
      expect { res.like?(nil) }.to raise_error(/Can't compare with object type: NilClass/)
    end

    context 'when comparing similar objects inside arrays' do
      it 'should return true' do
        options = { uri: '/rest/fake', list: [{ uri: '/rest/child/1', tag: 'not_to_compare' }, { uri: '/rest/child/2', tag: 'not_to_compare' }] }
        res = OneviewSDK::Resource.new(@client_200, options)
        expect(res.like?(uri: '/rest/fake', list: [{ uri: '/rest/child/2' }, { uri: '/rest/child/1' }])).to eq(true)
        expect(res.like?(uri: '/rest/fake', list: [{ uri: '/rest/child/1' }])).to eq(true)
      end

      it 'should return true if array is empty' do
        options = { uri: '/rest/fake', list: [] }
        res = OneviewSDK::Resource.new(@client_200, options)
        expect(res.like?(uri: '/rest/fake', list: [])).to eq(true)
      end

      it 'should return true if value is nil' do
        options = { uri: '/rest/fake', list: nil }
        res = OneviewSDK::Resource.new(@client_200, options)
        expect(res.like?(uri: '/rest/fake', list: nil)).to eq(true)
      end

      it 'should return true with more than one depth level using array' do
        options = { uri: '/rest/fake', list: [{ children: [{ name: 'level_2_child' }] }, { children: [{ name: 'level_2_child' }] }] }
        res = OneviewSDK::Resource.new(@client_200, options)
        expect(res.like?(uri: '/rest/fake', list: [{ children: [{ name: 'level_2_child' }] }])).to eq(true)
      end

      it 'should return true with values that are not a Hash' do
        options = { uri: '/rest/fake', list: %w[value_1 value_2] }
        res = OneviewSDK::Resource.new(@client_200, options)
        expect(res.like?(uri: '/rest/fake', list: %w[value_1 value_2])).to eq(true)
      end
    end

    context 'when comparing different objects inside arrays' do
      it 'should return false comparing with wrong value' do
        options = { uri: '/rest/fake', list: [{ uri: '/rest/child/1', tag: 'not_to_compare' }, { uri: '/rest/child/2', tag: 'not_to_compare' }] }
        res = OneviewSDK::Resource.new(@client_200, options)
        expect(res.like?(uri: '/rest/fake', list: [{ uri: '/rest/child/3' }])).to eq(false)
      end

      it 'should return false comparing with empty array' do
        options = { uri: '/rest/fake', list: [{ uri: '/rest/child/1', tag: 'not_to_compare' }, { uri: '/rest/child/2', tag: 'not_to_compare' }] }
        res = OneviewSDK::Resource.new(@client_200, options)
        expect(res.like?(uri: '/rest/fake', list: [])).to eq(false)
      end

      it 'should return false if the array inside Resource that called the method is empty' do
        options = { uri: '/rest/fake', list: [] }
        res = OneviewSDK::Resource.new(@client_200, options)
        expect(res.like?(uri: '/rest/fake', list: [{ uri: '/rest/child/1' }])).to eq(false)
      end

      it 'should return false if the value of array inside Resource that called the method is nil' do
        options = { uri: '/rest/fake', list: nil }
        res = OneviewSDK::Resource.new(@client_200, options)
        expect(res.like?(uri: '/rest/fake', list: [{ uri: '/rest/child/1' }])).to eq(false)
      end

      it 'should return false with more than one depth level using array' do
        options = { uri: '/rest/fake', list: [{ children: [{ name: 'level_2_child' }] }] }
        res = OneviewSDK::Resource.new(@client_200, options)
        expect(res.like?(uri: '/rest/fake', list: [{ children: [{ name: 'level_1_child' }] }])).to eq(false)
      end

      it 'should return false with values that are not a Hash' do
        options = { uri: '/rest/fake', list: %(value_1 value_2) }
        res = OneviewSDK::Resource.new(@client_200, options)
        expect(res.like?(uri: '/rest/fake', list: ['value_1'])).to eq(false)
      end
    end
  end

  describe '#create' do
    it 'should have the default parameter header' do
      res = OneviewSDK::Resource.new(@client_200, name: 'Name')
      expect(@client_200).to receive(:rest_post)
        .with(described_class::BASE_URI, { 'body' => { 'name' => 'Name' } }, @client_200.api_version)
        .and_return(FakeResponse.new)
      res.create
    end

    it 'it can override the default parameter header' do
      res = OneviewSDK::Resource.new(@client_200, name: 'Name')
      expect(@client_200).to receive(:rest_post)
        .with(described_class::BASE_URI, { :some_header => 'some_value', 'body' => { 'name' => 'Name' } }, @client_200.api_version)
        .and_return(FakeResponse.new)
      res.create(some_header: 'some_value')
    end

    it 'requires the client to be set' do
      res = OneviewSDK::Resource.new(@client_200)
      res.client = nil
      expect { res.create }.to raise_error(OneviewSDK::IncompleteResource, /Please set client attribute/)
    end

    it 'sets the data from the response' do
      res = OneviewSDK::Resource.new(@client_200, name: 'Name')
      fake_response = FakeResponse.new(res.data.merge(uri: '/rest/fake'))
      allow(@client_200).to receive(:rest_post).and_return(fake_response)
      res.create
      expect(res['uri']).to eq('/rest/fake')
    end

    it 'raises an error if the request failed' do
      res = OneviewSDK::Resource.new(@client_200, name: 'Name')
      fake_response = FakeResponse.new({ message: 'Invalid' }, 400)
      allow(@client_200).to receive(:rest_post).and_return(fake_response)
      expect { res.create }.to raise_error(OneviewSDK::BadRequest, /400 BAD REQUEST {"message":"Invalid"}/)
    end
  end

  describe '#create!' do
    before :each do
      @res = OneviewSDK::Resource.new(@client_200, name: 'Name')
    end

    it 'should have the default parameter header' do
      allow_any_instance_of(@res.class).to receive(:retrieve!).with({}).and_return(true)
      allow_any_instance_of(@res.class).to receive(:delete).with({}).and_return(true)
      expect(@res).to receive(:create).with({})
      @res.create!
    end

    it 'it can override the default parameter header' do
      allow_any_instance_of(@res.class).to receive(:retrieve!).with(some_header: 'some_value').and_return(true)
      allow_any_instance_of(@res.class).to receive(:delete).with(some_header: 'some_value').and_return(true)
      expect(@res).to receive(:create).with(some_header: 'some_value')
      @res.create!(some_header: 'some_value')
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
    it 'should have the default parameter header' do
      res = OneviewSDK::Resource.new(@client_200, name: 'Name', uri: '/rest/fake')
      fake_response = FakeResponse.new(res.data.merge(name: 'NewName', description: 'Blah'))
      expect(@client_200).to receive(:rest_get).with('/rest/fake', {}, @client_200.api_version).and_return(fake_response)
      res.refresh
    end

    it 'it can override the default parameter header' do
      res = OneviewSDK::Resource.new(@client_200, name: 'Name', uri: '/rest/fake')
      fake_response = FakeResponse.new(res.data.merge(name: 'NewName', description: 'Blah'))
      expect(@client_200).to receive(:rest_get).with('/rest/fake', { some_header: 'some_value' }, @client_200.api_version).and_return(fake_response)
      res.refresh(some_header: 'some_value')
    end

    it 'requires the client to be set' do
      res = OneviewSDK::Resource.new(@client_200)
      res.client = nil
      expect { res.refresh }.to raise_error(OneviewSDK::IncompleteResource, /Please set client attribute/)
    end

    it 'requires the uri to be set' do
      res = OneviewSDK::Resource.new(@client_200)
      expect { res.refresh }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'sets the data from the server\'s response' do
      res = OneviewSDK::Resource.new(@client_200, name: 'Name', uri: '/rest/fake')
      fake_response = FakeResponse.new(res.data.merge(name: 'NewName', description: 'Blah'))
      allow(@client_200).to receive(:rest_get).and_return(fake_response)
      res.refresh
      expect(res['name']).to eq('NewName')
      expect(res['description']).to eq('Blah')
    end
  end

  describe '#update' do
    it 'should have the default parameter header' do
      res = OneviewSDK::Resource.new(@client_200, name: 'Name', uri: '/rest/fake')
      expect(@client_200).to receive(:rest_put).with(res['uri'], { 'body' => res.data }, res.api_version).and_return(FakeResponse.new)
      res.update
    end

    it 'it can override the default parameter header' do
      res = OneviewSDK::Resource.new(@client_200, name: 'Name', uri: '/rest/fake')
      expect(@client_200).to receive(:rest_put)
        .with(res['uri'], { :some_header => 'some_value', 'body' => res.data }, res.api_version).and_return(FakeResponse.new)
      res.update({}, some_header: 'some_value')
    end

    it 'requires the client to be set' do
      res = OneviewSDK::Resource.new(@client_200)
      res.client = nil
      expect { res.update }.to raise_error(OneviewSDK::IncompleteResource, /Please set client attribute/)
    end

    it 'requires the uri to be set' do
      res = OneviewSDK::Resource.new(@client_200)
      expect { res.update }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'uses the rest_put method to update the data' do
      res = OneviewSDK::Resource.new(@client_200, name: 'Name', uri: '/rest/fake')
      expect(@client_200).to receive(:rest_put).with(res['uri'], { 'body' => res.data }, res.api_version).and_return(FakeResponse.new)
      res.update
    end

    it 'raises an error if the update fails' do
      res = OneviewSDK::Resource.new(@client_200, name: 'Name', uri: '/rest/fake')
      fake_response = FakeResponse.new({ message: 'Invalid' }, 400)
      expect(@client_200).to receive(:rest_put).with(res['uri'], { 'body' => res.data }, res.api_version).and_return(fake_response)
      expect { res.update }.to raise_error(OneviewSDK::BadRequest, /400 BAD REQUEST {"message":"Invalid"}/)
    end
  end

  describe '#delete' do
    it 'should have the default parameter header' do
      res = OneviewSDK::Resource.new(@client_200, name: 'Name', uri: '/rest/fake')
      expect(@client_200).to receive(:rest_delete).with(res['uri'], {}, res.api_version).and_return(FakeResponse.new)
      res.delete
    end

    it 'it can override the default parameter header' do
      res = OneviewSDK::Resource.new(@client_200, name: 'Name', uri: '/rest/fake')
      expect(@client_200).to receive(:rest_delete).with(res['uri'], { some_header: 'some_value' }, res.api_version).and_return(FakeResponse.new)
      res.delete(some_header: 'some_value')
    end

    it 'requires the client to be set' do
      res = OneviewSDK::Resource.new(@client_200)
      res.client = nil
      expect { res.delete }.to raise_error(OneviewSDK::IncompleteResource, /Please set client attribute/)
    end

    it 'requires the uri to be set' do
      res = OneviewSDK::Resource.new(@client_200)
      expect { res.delete }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'returns true if the delete was successful' do
      res = OneviewSDK::Resource.new(@client_200, name: 'Name', uri: '/rest/fake')
      expect(@client_200).to receive(:rest_delete).with(res['uri'], {}, res.api_version).and_return(FakeResponse.new)
      expect(res.delete).to eq(true)
    end

    it 'raises an error if the delete fails' do
      res = OneviewSDK::Resource.new(@client_200, name: 'Name', uri: '/rest/fake')
      fake_response = FakeResponse.new({ message: 'Invalid' }, 400)
      expect(@client_200).to receive(:rest_delete).with(res['uri'], {}, res.api_version).and_return(fake_response)
      expect { res.delete }.to raise_error(OneviewSDK::BadRequest, /400 BAD REQUEST {"message":"Invalid"}/)
    end
  end

  describe '#to_file' do
    let(:file_like_object) { double('file like object') }

    before :each do
      @res = OneviewSDK::Enclosure.new(@client_200, name: 'Name', uri: '/rest/fake')
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
      expect(OneviewSDK::Resource).to receive(:schema).with(@client_200)
      OneviewSDK::Resource.new(@client_200).schema
    end

    it 'tries to get BASE_URI/schema' do
      expect(@client_200).to receive(:rest_get).with("#{OneviewSDK::Resource::BASE_URI}/schema", {}, @client_200.api_version)
                                               .and_return(FakeResponse.new(key: 'val1', other_key: 'val2'))
      schema = OneviewSDK::Resource.schema(@client_200)
      expect(schema['key']).to eq('val1')
      expect(schema['other_key']).to eq('val2')
    end

    it 'displays a nice error if the schema endpoint returns a 404 response' do
      fake_response = FakeResponse.new({ message: 'Not Found' }, 404)
      allow(@client_200).to receive(:rest_get).and_return(fake_response)
      expect(@client_200.logger).to receive(:error).with(/does not implement the schema endpoint/)
      expect { OneviewSDK::Resource.schema(@client_200) }.to raise_error(OneviewSDK::NotFound, /404 NOT FOUND/)
    end
  end

  describe '#find_by' do
    it 'should have the default parameter header' do
      expect(described_class).to receive(:find_with_pagination).with(@client_200, described_class::BASE_URI, {}).and_return([])
      described_class.find_by(@client_200, name: 'attribute name')
    end

    it 'it can override the default parameter header' do
      expect(described_class).to receive(:find_with_pagination)
        .with(@client_200, 'some-uri/123', some_header: 'some_value').and_return([])
      described_class.find_by(@client_200, { name: 'attribute name' }, 'some-uri/123', some_header: 'some_value')
    end

    it 'should call #find_with_pagination with correct client and correct uri' do
      expect(OneviewSDK::Enclosure).to receive(:find_with_pagination).with(@client_200, OneviewSDK::Enclosure::BASE_URI, {}).and_return([])
      OneviewSDK::Enclosure.find_by(@client_200, {})
    end

    it 'returns an empty array if no results are found' do
      fake_response = FakeResponse.new(members: [])
      allow(@client_200).to receive(:rest_get).and_return(fake_response)
      res = OneviewSDK::Enclosure.find_by(@client_200, {})
      expect(res.size).to eq(0)
    end

    it 'returns an array of resources if results are found' do
      fake_response = FakeResponse.new(members: [
        { name: 'Enc1', uri: "#{OneviewSDK::Enclosure::BASE_URI}/1", state: 'Monitored' },
        { name: 'Enc2', uri: "#{OneviewSDK::Enclosure::BASE_URI}/2", state: 'Adding' },
        { name: 'Enc3', uri: "#{OneviewSDK::Enclosure::BASE_URI}/3", state: 'Monitored' },
        { name: 'Enc4', uri: "#{OneviewSDK::Enclosure::BASE_URI}/4" }
      ])
      allow(@client_200).to receive(:rest_get).and_return(fake_response)
      res = OneviewSDK::Enclosure.find_by(@client_200, state: 'Monitored')
      expect(res.size).to eq(2)
      res.each do |r|
        expect(r.class).to eq(OneviewSDK::Enclosure)
        expect(r['state']).to eq('Monitored')
      end
    end
  end

  describe '#find_with_pagination' do
    it 'should have the default parameter header' do
      expect(@client_200).to receive(:rest_get).with('some_uri/123', {}).and_return(FakeResponse.new(members: []))
      described_class.find_with_pagination(@client_200, 'some_uri/123')
    end

    it 'it can override the default parameter header' do
      expect(@client_200).to receive(:rest_get).with('some_uri/123', some_header: 'some_value').and_return(FakeResponse.new(members: []))
      described_class.find_with_pagination(@client_200, 'some_uri/123', some_header: 'some_value')
    end

    it 'returns an empty array if no results are found' do
      fake_response = FakeResponse.new(members: [])
      allow(@client_200).to receive(:rest_get).and_return(fake_response)
      res = OneviewSDK::Enclosure.find_with_pagination(@client_200, 'some_uri/123')
      expect(res.size).to eq(0)
    end

    context 'when there are many pages' do
      context "and, in the last page, body['nextPageUri'] is nil" do
        it 'should return all resources' do
          fake_response_1 = FakeResponse.new(members: [
            { name: 'Enc1', uri: "#{OneviewSDK::Enclosure::BASE_URI}/1" },
            { name: 'Enc2', uri: "#{OneviewSDK::Enclosure::BASE_URI}/2" }
          ], nextPageUri: 'page/2', uri: 'page/1')

          fake_response_2 = FakeResponse.new(members: [
            { name: 'Enc3', uri: "#{OneviewSDK::Enclosure::BASE_URI}/3" },
            { name: 'Enc4', uri: "#{OneviewSDK::Enclosure::BASE_URI}/4" }
          ], uri: 'page/2')

          expect(@client_200).to receive(:rest_get).and_return(fake_response_1)
          expect(@client_200).to receive(:rest_get).and_return(fake_response_2)
          res = OneviewSDK::Enclosure.find_with_pagination(@client_200, 'some_uri/123')
          expect(res.size).to eq(4)
          res.each_with_index do |r, index|
            expect(r['name']).to eq("Enc#{index + 1}")
          end
        end
      end

      context "and, in the last page, body['uri'] is equals to body['nextPageUri']" do
        it 'should returns all resources' do
          fake_response_1 = FakeResponse.new(members: [
            { name: 'Enc1', uri: "#{OneviewSDK::Enclosure::BASE_URI}/1" },
            { name: 'Enc2', uri: "#{OneviewSDK::Enclosure::BASE_URI}/2" }
          ], nextPageUri: 'page/2', uri: 'page/1')

          fake_response_2 = FakeResponse.new(members: [
            { name: 'Enc3', uri: "#{OneviewSDK::Enclosure::BASE_URI}/3" },
            { name: 'Enc4', uri: "#{OneviewSDK::Enclosure::BASE_URI}/4" }
          ], nextPageUri: 'page/2', uri: 'page/2')

          expect(@client_200).to receive(:rest_get).and_return(fake_response_1)
          expect(@client_200).to receive(:rest_get).and_return(fake_response_2)
          res = OneviewSDK::Enclosure.find_with_pagination(@client_200, 'some_uri/123')
          expect(res.size).to eq(4)
          res.each_with_index do |r, index|
            expect(r['name']).to eq("Enc#{index + 1}")
          end
        end
      end
    end
  end

  describe '#get_all' do
    it 'calls find_by with an empty attributes hash' do
      expect(OneviewSDK::Resource).to receive(:find_by).with(@client_200, {}, described_class::BASE_URI, {})
      OneviewSDK::Resource.get_all(@client_200)
    end

    it 'it can override the default parameter header' do
      expect(OneviewSDK::Resource).to receive(:find_by).with(@client_200, {}, described_class::BASE_URI, some_header: 'some_value')
      OneviewSDK::Resource.get_all(@client_200, some_header: 'some_value')
    end
  end

  describe '#build_query' do
    it 'builds basic query' do
      expect(OneviewSDK::Resource.build_query('test' => 'TEST')).to eq('?test=TEST')
    end

    it 'builds resource query' do
      fake_resource = OneviewSDK::Resource.new(@client_200, 'uri' => 'URI')
      expect(OneviewSDK::Resource.build_query('this_resource' => fake_resource)).to eq('?thisResourceUri=URI')
    end

    it 'builds composed query' do
      fake_resource = OneviewSDK::Resource.new(@client_200, 'uri' => 'URI')
      expect(OneviewSDK::Resource.build_query('test' => 'TEST', 'this_resource' => fake_resource)).to eq('?test=TEST&thisResourceUri=URI')
    end

    it 'returns empty String for invalid values' do
      expect(OneviewSDK::Resource.build_query('')).to eq('')
      expect(OneviewSDK::Resource.build_query(nil)).to eq('')
    end
  end

  describe '#get_all_with_query' do
    it 'retrieves all based on a query' do
      allow(@client_600).to receive(:build_query)
        .with(@client_600, { 'scopeUris' => 'ResourceURI' }, described_class::BASE_URI, {}).and_return('?scopeUris=ResourceURI')
      expect(OneviewSDK::Resource).to receive(:find_with_pagination).with(@client_200, described_class::BASE_URI + '/?scopeuris=ResourceURI')
      OneviewSDK::Resource.get_all_with_query(@client_200, 'scopeUris' => 'ResourceURI')
    end
  end
end

RSpec.describe OneviewSDK do
  describe '#resource_named' do
    it 'gets the correct resource class' do
      expect(OneviewSDK.resource_named('ServerProfile')).to eq(OneviewSDK::ServerProfile)
      expect(OneviewSDK.resource_named('FCoENetwork')).to eq(OneviewSDK::FCoENetwork)
    end

    it 'allows you to set the api version to look in' do
      expect(OneviewSDK.resource_named('ServerProfile', 200)).to eq(OneviewSDK::API200::ServerProfile)
      expect(OneviewSDK.resource_named('FCoENetwork', 300)).to eq(OneviewSDK::API300::FCoENetwork)
    end

    it 'allows you to set the api variant to look in' do
      expect(OneviewSDK.resource_named('ServerProfile', 200, 'C7000')).to eq(OneviewSDK::API200::ServerProfile)
      expect(OneviewSDK.resource_named('FCoENetwork', 300, 'C7000')).to eq(OneviewSDK::API300::C7000::FCoENetwork)
    end

    it 'gets resource classes that are not children of Resource' do
      expect(OneviewSDK.resource_named('FirmwareBundle')).to eq(OneviewSDK::FirmwareBundle)
      expect(OneviewSDK.resource_named('FirmwareBundle', 300)).to eq(OneviewSDK::API300::FirmwareBundle)
    end

    it 'ignores case of the resource name' do
      expect(OneviewSDK.resource_named('SERVERProfilE')).to eq(OneviewSDK::ServerProfile)
    end

    it 'ignores dashes, underscores & spaces in the resource name' do
      expect(OneviewSDK.resource_named('se rver-prof_ile')).to eq(OneviewSDK::ServerProfile)
    end

    it 'supports resource name symbols' do
      expect(OneviewSDK.resource_named(:server_profile)).to eq(OneviewSDK::ServerProfile)
    end

    it 'raises an error if the api_version is not supported' do
      expect { OneviewSDK.resource_named(:server_profile, 15) }
        .to raise_error(OneviewSDK::UnsupportedVersion, /not supported/)
    end

    it 'returns nil if the resource name is not defined' do
      expect(OneviewSDK.resource_named(:fakeResource)).to be_nil
    end
  end
end
