require 'spec_helper'
require 'time'

RSpec.describe OneviewSDK::API300::Synergy::Enclosure do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::Enclosure
  end

  describe '#initialize' do
    context 'OneView 2.0' do
      it 'sets the defaults correctly' do
        enclosure = OneviewSDK::API300::Synergy::Enclosure.new(@client_300)
        expect(enclosure[:type]).to eq('EnclosureV300')
      end
    end
  end

  describe '#add' do
    context 'with valid data' do
      before :each do
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_post).and_return(FakeResponse.new({}, 202))
        allow_any_instance_of(OneviewSDK::Client).to receive(:wait_for).and_return(FakeResponse.new(nil, 200, 'fake' => { 'fake_stuff' => 'fake' }))
        allow_any_instance_of(described_class).to receive(:update).and_return(true)
        @data = {
          'name' => 'Fake-Enclosure',
          'hostname' => ENCL_HOSTNAME,
          'managerBays' => [{ 'ipAddress' => ENCL_HOSTNAME }],
          'frameLinkModuleDomain' => 'test',
          'uri' => '/rest/fake_uri'
        }
        @enclosure = described_class.new(@client_300, @data)
        @enclosure2 = described_class.new(@client_300, @data)
        @enclosure3 = described_class.new(@client_300, @data)
        @enclosures_added = [@enclosure, @enclosure2, @enclosure3]
        allow(described_class).to receive(:find_by).with(@client_300, {}).and_return(@enclosures_added)
      end

      it 'only sends certain attributes on the POST' do
        expect(@client_300).to receive(:rest_post).with('/rest/enclosures', { 'body' => { 'hostname' => @data['hostname'] } }, anything)
        @enclosure.add
      end

      it 'sets the enclosure name correctly' do
        test = @enclosure.add
        expect(test.last[:name]).to eq('Fake-Enclosure1')
      end
    end

    context 'with invalid data' do
      it 'fails when certain attributes are not set' do
        enclosure = OneviewSDK::API300::Synergy::Enclosure.new(@client_300, {})
        expect { enclosure.add }.to raise_error(OneviewSDK::IncompleteResource, /Missing required attribute/)
      end
    end
  end

  describe '#update' do
    before :each do
      @item  = OneviewSDK::API300::Synergy::Enclosure.new(@client_300, name: 'E1', rackName: 'R1', uri: '/rest/fake')
      @item2 = OneviewSDK::API300::Synergy::Enclosure.new(@client_300, name: 'E2', rackName: 'R1', uri: '/rest/fake2')
      @item3 = OneviewSDK::API300::Synergy::Enclosure.new(@client_300, name: 'E1', rackName: 'R2', uri: '/rest/fake2')
    end

    it 'requires a uri' do
      expect { OneviewSDK::API300::Synergy::Enclosure.new(@client_300).update }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does not send a PATCH request if the name and rackName are the same' do
      expect(OneviewSDK::API300::Synergy::Enclosure).to receive(:find_by).with(@client_300, uri: @item['uri']).and_return([@item])
      expect(@client_300).to_not receive(:rest_patch)
      @item.update
    end

    it 'updates the server name with the local name' do
      expect(OneviewSDK::API300::Synergy::Enclosure).to receive(:find_by).with(@client_300, uri: @item['uri']).and_return([@item2])
      expect(@client_300).to receive(:rest_patch)
        .with(@item['uri'], { 'body' => [{ op: 'replace', path: '/name', value: @item['name'] }] }, @item.api_version)
        .and_return(FakeResponse.new)
      @item.update
    end

    it 'updates the server rackName with the local rackName' do
      expect(OneviewSDK::API300::Synergy::Enclosure).to receive(:find_by).with(@client_300, uri: @item['uri']).and_return([@item3])
      expect(@client_300).to receive(:rest_patch)
        .with(@item['uri'], { 'body' => [{ op: 'replace', path: '/rackName', value: @item['rackName'] }] }, @item.api_version)
        .and_return(FakeResponse.new)
      @item.update
    end
  end

  describe '#remove' do
    it 'removes enclosure' do
      item = OneviewSDK::API300::Synergy::Enclosure.new(@client_300, name: 'E1', rackName: 'R1', uri: '/rest/enclosures/encl1')
      expect(@client_300).to receive(:rest_delete).with('/rest/enclosures/encl1', {}, 300).and_return(FakeResponse.new({}))
      item.remove
    end
  end

  describe '#configuration' do
    it 'requires a uri' do
      expect { OneviewSDK::API300::Synergy::Enclosure.new(@client_300).configuration }.to raise_error(OneviewSDK::IncompleteResource,
                                                                                                          /Please set uri/)
    end

    it 'does a PUT to /uri/configuration and updates the attributes' do
      item = OneviewSDK::API300::Synergy::Enclosure.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_put).with('/rest/fake/configuration', {}, item.api_version)
        .and_return(FakeResponse.new(name: 'NewName'))
      item.configuration
      expect(item['name']).to eq('NewName')
    end
  end

  describe '#set_refresh_state' do
    it 'requires a uri' do
      expect { OneviewSDK::API300::Synergy::Enclosure.new(@client_300).set_refresh_state(:state) }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a PUT to /refreshState' do
      item = OneviewSDK::API300::Synergy::Enclosure.new(@client_300, uri: '/rest/fake', refreshState: 'NotRefreshing')
      expect(@client_300).to receive(:rest_put).with(item['uri'] + '/refreshState', Hash, item.api_version)
        .and_return(FakeResponse.new(refreshState: 'Refreshing'))
      item.set_refresh_state('Refreshing')
      expect(item['refreshState']).to eq('Refreshing')
    end

    it 'allows string or symbol refreshState values' do
      item = OneviewSDK::API300::Synergy::Enclosure.new(@client_300, uri: '/rest/fake', refreshState: 'NotRefreshing')
      expect(@client_300).to receive(:rest_put).with(item['uri'] + '/refreshState', Hash, item.api_version)
        .and_return(FakeResponse.new(refreshState: 'Refreshing'))
      item.set_refresh_state(:Refreshing)
      expect(item['refreshState']).to eq('Refreshing')
    end
  end

  describe '#script' do
    it 'requires a uri' do
      expect { OneviewSDK::API300::Synergy::Enclosure.new(@client_300).script }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'gets uri/script' do
      item = OneviewSDK::API300::Synergy::Enclosure.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with('/rest/fake/script', item.api_version).and_return(FakeResponse.new('Blah'))
      expect(@client_300.logger).to receive(:warn).with(/Failed to parse JSON response/).and_return(true)
      expect(item.script).to eq('Blah')
    end
  end

  describe '#environmentalConfiguration' do
    it 'requires a uri' do
      expect { OneviewSDK::API300::Synergy::Enclosure.new(@client_300).environmental_configuration }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'gets uri/environmentalConfiguration' do
      item = OneviewSDK::API300::Synergy::Enclosure.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with('/rest/fake/environmentalConfiguration', item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      expect(item.environmental_configuration).to eq('key' => 'val')
    end
  end

  describe '#set_environmental_configuration' do
    it 'does not allow the method' do
      enclosure = OneviewSDK::API300::Synergy::Enclosure.new(@client)
      expect { enclosure.set_environmental_configuration }
        .to raise_error(OneviewSDK::MethodUnavailable, /The method #set_environmental_configuration is unavailable for this resource/)
    end
  end

  describe '#utilization' do
    it 'requires a uri' do
      expect { OneviewSDK::API300::Synergy::Enclosure.new(@client_300).utilization }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'gets uri/utilization' do
      item = OneviewSDK::API300::Synergy::Enclosure.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with('/rest/fake/utilization', item.api_version).and_return(FakeResponse.new(key: 'val'))
      expect(item.utilization).to eq('key' => 'val')
    end

    it 'takes query parameters' do
      item = OneviewSDK::API300::Synergy::Enclosure.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with('/rest/fake/utilization?key=val', item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      expect(item.utilization(key: :val)).to eq('key' => 'val')
    end

    it 'takes an array for the :fields query parameter' do
      item = OneviewSDK::API300::Synergy::Enclosure.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with('/rest/fake/utilization?fields=one,two,three', item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      expect(item.utilization(fields: %w(one two three))).to eq('key' => 'val')
    end

    it 'converts Time query parameters' do
      t = Time.now
      item = OneviewSDK::API300::Synergy::Enclosure.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with("/rest/fake/utilization?filter=startDate=#{t.utc.iso8601(3)}", item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      expect(item.utilization(startDate: t)).to eq('key' => 'val')
    end
  end

  describe '#updateAttribute' do
    it 'requires a uri' do
      expect { OneviewSDK::API300::Synergy::Enclosure.new(@client_300).patch(:op, :path, :val) }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a PATCH to the enclosure uri with all parameters' do
      item = OneviewSDK::API300::Synergy::Enclosure.new(@client_300, uri: '/rest/fake')
      data = { 'body' => [{ op: 'operation', path: '/path', value: 'val' }] }
      expect(@client_300).to receive(:rest_patch).with('/rest/fake', data, item.api_version).and_return(FakeResponse.new(key: 'Val'))
      expect(item.patch('operation', '/path', 'val')).to eq('key' => 'Val')
    end

    it 'does a PATCH to the enclosure uri with 2 parameters' do
      item = OneviewSDK::API300::C7000::Enclosure.new(@client_300, uri: '/rest/fake')
      data = { 'body' => [{ op: 'operation', path: '/path' }] }
      expect(@client_300).to receive(:rest_patch).with('/rest/fake', data, item.api_version).and_return(FakeResponse.new(key: 'Op'))
      expect(item.patch('operation', '/path')).to eq('key' => 'Op')
    end
  end

  describe '#convert_time' do
    before :each do
      @item = OneviewSDK::API300::Synergy::Enclosure.new(@client_300)
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
      enclosure = OneviewSDK::API300::Synergy::Enclosure.new(@client_300)
      expect { enclosure.create }.to raise_error(OneviewSDK::MethodUnavailable, /The method #create is unavailable for this resource/)
    end

    it 'does not allow the delete action' do
      enclosure = OneviewSDK::API300::Synergy::Enclosure.new(@client_300)
      expect { enclosure.delete }.to raise_error(OneviewSDK::MethodUnavailable, /The method #delete is unavailable for this resource/)
    end
  end
end
