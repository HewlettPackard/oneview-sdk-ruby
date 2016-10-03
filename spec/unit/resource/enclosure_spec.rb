require 'spec_helper'
require 'time'

RSpec.describe OneviewSDK::Enclosure do
  include_context 'shared context'

  describe '#initialize' do
    context 'OneView 2.0' do
      it 'sets the defaults correctly' do
        enclosure = OneviewSDK::Enclosure.new(@client)
        expect(enclosure[:type]).to eq('EnclosureV200')
      end
    end
  end

  describe '#retrieve!' do
    before :each do
      resp = FakeResponse.new(members: [
        { name: 'name1', uri: 'uri1', serialNumber: 'sn1', activeOaPreferredIP: 'aip1', standbyOaPreferredIP: 'sip1' },
        { name: 'name2', uri: 'uri2', serialNumber: 'sn2', activeOaPreferredIP: 'aip2', standbyOaPreferredIP: 'sip2' }
      ])
      allow(@client).to receive(:rest_get).with(described_class::BASE_URI).and_return(resp)
    end

    it 'retrieves by name' do
      expect(described_class.new(@client, name: 'name1').retrieve!).to be true
      expect(described_class.new(@client, name: 'fake').retrieve!).to be false
    end

    it 'retrieves by uri' do
      expect(described_class.new(@client, uri: 'uri1').retrieve!).to be true
      expect(described_class.new(@client, uri: 'fake').retrieve!).to be false
    end

    it 'retrieves by serialNumber' do
      expect(described_class.new(@client, serialNumber: 'sn1').retrieve!).to be true
      expect(described_class.new(@client, serialNumber: 'fake').retrieve!).to be false
    end

    it 'retrieves by activeOaPreferredIP' do
      expect(described_class.new(@client, activeOaPreferredIP: 'aip1').retrieve!).to be true
      expect(described_class.new(@client, activeOaPreferredIP: 'fake').retrieve!).to be false
    end

    it 'retrieves by standbyOaPreferredIP' do
      expect(described_class.new(@client, standbyOaPreferredIP: 'sip1').retrieve!).to be true
      expect(described_class.new(@client, standbyOaPreferredIP: 'fake').retrieve!).to be false
    end
  end

  describe '#exists?' do
    before :each do
      resp = FakeResponse.new(members: [
        { name: 'name1', uri: 'uri1', serialNumber: 'sn1', activeOaPreferredIP: 'aip1', standbyOaPreferredIP: 'sip1' },
        { name: 'name2', uri: 'uri2', serialNumber: 'sn2', activeOaPreferredIP: 'aip2', standbyOaPreferredIP: 'sip2' }
      ])
      allow(@client).to receive(:rest_get).with(described_class::BASE_URI).and_return(resp)
    end

    it 'finds it by name' do
      expect(described_class.new(@client, name: 'name1').exists?).to be true
      expect(described_class.new(@client, name: 'fake').exists?).to be false
    end

    it 'finds it by uri' do
      expect(described_class.new(@client, uri: 'uri1').exists?).to be true
      expect(described_class.new(@client, uri: 'fake').exists?).to be false
    end

    it 'finds it by serialNumber' do
      expect(described_class.new(@client, serialNumber: 'sn1').exists?).to be true
      expect(described_class.new(@client, serialNumber: 'fake').exists?).to be false
    end

    it 'finds it by activeOaPreferredIP' do
      expect(described_class.new(@client, activeOaPreferredIP: 'aip1').exists?).to be true
      expect(described_class.new(@client, activeOaPreferredIP: 'fake').exists?).to be false
    end

    it 'finds it by standbyOaPreferredIP' do
      expect(described_class.new(@client, standbyOaPreferredIP: 'sip1').exists?).to be true
      expect(described_class.new(@client, standbyOaPreferredIP: 'fake').exists?).to be false
    end
  end

  describe '#add' do
    context 'with valid data' do
      before :each do
        allow_any_instance_of(OneviewSDK::Enclosure).to receive(:update).and_return(true)
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_api).and_return(true)
        allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(name: 'Encl1', serialNumber: 'Fake', uri: '/rest/fake')

        @data = {
          'name' => 'Fake-Enclosure',
          'hostname' => '1.1.1.1',
          'username' => 'Admin',
          'password' => 'secret123',
          'enclosureGroupUri' => '/rest/enclosure-groups/fake',
          'licensingIntent' => 'OneView',
          'force' => true
        }
        @enclosure = OneviewSDK::Enclosure.new(@client, @data)
      end

      it 'only sends certain attributes on the POST' do
        expect(@client).to receive(:rest_post).with('/rest/enclosures', { 'body' => @data.select { |k, _v| k != 'name' } }, anything)
        @enclosure.add
      end

      it 'sets the enclosure name correctly' do
        @enclosure.add
        expect(@enclosure[:name]).to eq('Fake-Enclosure')
      end

      it 'uses the given name if one is not specified' do
        @enclosure.data.delete('name')
        @enclosure.add
        expect(@enclosure[:name]).to eq('Encl1')
      end
    end

    context 'with invalid data' do
      it 'fails when certain attributes are not set' do
        enclosure = OneviewSDK::Enclosure.new(@client, {})
        expect { enclosure.add }.to raise_error(OneviewSDK::IncompleteResource, /Missing required attribute/)
      end
    end
  end

  describe '#update' do
    before :each do
      @item  = OneviewSDK::Enclosure.new(@client, name: 'E1', rackName: 'R1', uri: '/rest/fake')
      @item2 = OneviewSDK::Enclosure.new(@client, name: 'E2', rackName: 'R1', uri: '/rest/fake2')
      @item3 = OneviewSDK::Enclosure.new(@client, name: 'E1', rackName: 'R2', uri: '/rest/fake2')
    end

    it 'requires a uri' do
      expect { OneviewSDK::Enclosure.new(@client).update }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does not send a PATCH request if the name and rackName are the same' do
      expect(OneviewSDK::Enclosure).to receive(:find_by).with(@client, uri: @item['uri']).and_return([@item])
      expect(@client).to_not receive(:rest_patch)
      @item.update
    end

    it 'updates the server name with the local name' do
      expect(OneviewSDK::Enclosure).to receive(:find_by).with(@client, uri: @item['uri']).and_return([@item2])
      expect(@client).to receive(:rest_patch)
        .with(@item['uri'], { 'body' => [{ op: 'replace', path: '/name', value: @item['name'] }] }, @item.api_version)
        .and_return(FakeResponse.new)
      @item.update
    end

    it 'updates the server rackName with the local rackName' do
      expect(OneviewSDK::Enclosure).to receive(:find_by).with(@client, uri: @item['uri']).and_return([@item3])
      expect(@client).to receive(:rest_patch)
        .with(@item['uri'], { 'body' => [{ op: 'replace', path: '/rackName', value: @item['rackName'] }] }, @item.api_version)
        .and_return(FakeResponse.new)
      @item.update
    end
  end

  describe '#remove' do
    it 'removes enclosure' do
      item = OneviewSDK::Enclosure.new(@client, name: 'E1', rackName: 'R1', uri: '/rest/enclosures/encl1')
      expect(@client).to receive(:rest_delete).with('/rest/enclosures/encl1', {}, 200).and_return(FakeResponse.new({}))
      item.remove
    end
  end

  describe '#configuration' do
    it 'requires a uri' do
      expect { OneviewSDK::Enclosure.new(@client).configuration }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a PUT to /uri/configuration and updates the attributes' do
      item = OneviewSDK::Enclosure.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_put).with('/rest/fake/configuration', {}, item.api_version).and_return(FakeResponse.new(name: 'NewName'))
      item.configuration
      expect(item['name']).to eq('NewName')
    end
  end

  describe '#set_refresh_state' do
    it 'requires a uri' do
      expect { OneviewSDK::Enclosure.new(@client).set_refresh_state(:state) }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a PUT to /refreshState' do
      item = OneviewSDK::Enclosure.new(@client, uri: '/rest/fake', refreshState: 'NotRefreshing')
      expect(@client).to receive(:rest_put).with(item['uri'] + '/refreshState', Hash, item.api_version)
        .and_return(FakeResponse.new(refreshState: 'Refreshing'))
      item.set_refresh_state('Refreshing')
      expect(item['refreshState']).to eq('Refreshing')
    end

    it 'allows string or symbol refreshState values' do
      item = OneviewSDK::Enclosure.new(@client, uri: '/rest/fake', refreshState: 'NotRefreshing')
      expect(@client).to receive(:rest_put).with(item['uri'] + '/refreshState', Hash, item.api_version)
        .and_return(FakeResponse.new(refreshState: 'Refreshing'))
      item.set_refresh_state(:Refreshing)
      expect(item['refreshState']).to eq('Refreshing')
    end
  end

  describe '#script' do
    it 'requires a uri' do
      expect { OneviewSDK::Enclosure.new(@client).script }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'gets uri/script' do
      item = OneviewSDK::Enclosure.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with('/rest/fake/script', item.api_version).and_return(FakeResponse.new('Blah'))
      expect(@client.logger).to receive(:warn).with(/Failed to parse JSON response/).and_return(true)
      expect(item.script).to eq('Blah')
    end
  end

  describe '#environmentalConfiguration' do
    it 'requires a uri' do
      expect { OneviewSDK::Enclosure.new(@client).environmental_configuration }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'gets uri/environmentalConfiguration' do
      item = OneviewSDK::Enclosure.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with('/rest/fake/environmentalConfiguration', item.api_version).and_return(FakeResponse.new(key: 'val'))
      expect(item.environmental_configuration).to eq('key' => 'val')
    end
  end

  describe '#utilization' do
    it 'requires a uri' do
      expect { OneviewSDK::Enclosure.new(@client).utilization }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'gets uri/utilization' do
      item = OneviewSDK::Enclosure.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with('/rest/fake/utilization', item.api_version).and_return(FakeResponse.new(key: 'val'))
      expect(item.utilization).to eq('key' => 'val')
    end

    it 'takes query parameters' do
      item = OneviewSDK::Enclosure.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with('/rest/fake/utilization?key=val', item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      expect(item.utilization(key: :val)).to eq('key' => 'val')
    end

    it 'takes an array for the :fields query parameter' do
      item = OneviewSDK::Enclosure.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with('/rest/fake/utilization?fields=one,two,three', item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      expect(item.utilization(fields: %w(one two three))).to eq('key' => 'val')
    end

    it 'converts Time query parameters' do
      t = Time.now
      item = OneviewSDK::Enclosure.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with("/rest/fake/utilization?filter=startDate=#{t.utc.iso8601(3)}", item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      expect(item.utilization(startDate: t)).to eq('key' => 'val')
    end
  end

  describe '#updateAttribute' do
    it 'requires a uri' do
      expect { OneviewSDK::Enclosure.new(@client).patch(:op, :path, :val) }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a PATCH to the enclusre uri' do
      item = OneviewSDK::Enclosure.new(@client, uri: '/rest/fake')
      data = { 'body' => [{ op: 'operation', path: '/path', value: 'val' }] }
      expect(@client).to receive(:rest_patch).with('/rest/fake', data, item.api_version).and_return(FakeResponse.new(key: 'Val'))
      expect(item.patch('operation', '/path', 'val')).to eq('key' => 'Val')
    end
  end

  describe '#convert_time' do
    before :each do
      @item = OneviewSDK::Enclosure.new(@client)
      @t = Time.now
      @d = Date.today
    end

    it 'does not convert nil objects' do
      expect(@item.send(:convert_time, nil)).to eq(nil)
    end

    it 'converts Time strings to Time' do
      expect(@item.send(:convert_time, @t.to_s)).to match(@t.utc.iso8601.chop!)
    end

    it 'converts Date strings to Time' do
      expect(@item.send(:convert_time, @d.to_s)).to match(@d.to_time.utc.iso8601.chop!)
    end

    it 'accepts Date objects' do
      expect(@item.send(:convert_time, @d)).to match(@d.to_time.utc.iso8601.chop!)
    end

    it 'accepts Time objects' do
      expect(@item.send(:convert_time, @t)).to match(@t.utc.iso8601.chop!)
    end

    it 'does not accepts other types' do
      expect { @item.send(:convert_time, []) }.to raise_error(OneviewSDK::InvalidResource, /Invalid time format/)
    end

    it 'raises an error for invalid strings' do
      expect { @item.send(:convert_time, 'badtime') }.to raise_error(OneviewSDK::InvalidResource, /Failed to parse time/)
    end
  end

  describe 'undefined methods' do
    it 'does not allow the create action' do
      enclosure = OneviewSDK::Enclosure.new(@client)
      expect { enclosure.create }.to raise_error(OneviewSDK::MethodUnavailable, /The method #create is unavailable for this resource/)
    end

    it 'does not allow the delete action' do
      enclosure = OneviewSDK::Enclosure.new(@client)
      expect { enclosure.delete }.to raise_error(OneviewSDK::MethodUnavailable, /The method #delete is unavailable for this resource/)
    end
  end
end
