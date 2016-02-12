require 'spec_helper'

RSpec.describe OneviewSDK::Enclosure do
  include_context 'shared context'

  describe '#initialize' do
    context 'OneView 1.2' do
      it 'sets the defaults correctly' do
        enclosure = OneviewSDK::Enclosure.new(@client_120)
        expect(enclosure[:type]).to eq('EnclosureV2')
      end
    end

    context 'OneView 2.0' do
      it 'sets the defaults correctly' do
        enclosure = OneviewSDK::Enclosure.new(@client)
        expect(enclosure[:type]).to eq('EnclosureV200')
      end
    end
  end

  describe '#create' do
    context 'with valid data' do
      before :each do
        allow_any_instance_of(OneviewSDK::Enclosure).to receive(:save).and_return(true)
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
        @enclosure.create
      end

      it 'sets the enclosure name correctly' do
        @enclosure.create
        expect(@enclosure[:name]).to eq('Fake-Enclosure')
      end

      it 'uses the given name if one is not specified' do
        @enclosure.data.delete('name')
        @enclosure.create
        expect(@enclosure[:name]).to eq('Encl1')
      end
    end

    context 'with invalid data' do
      it 'fails when certain attributes are not set' do
        enclosure = OneviewSDK::Enclosure.new(@client, {})
        expect { enclosure.create }.to raise_error(/Missing required attribute/)
      end
    end
  end

  describe '#save' do
    it 'requires a uri' do
      expect { OneviewSDK::Enclosure.new(@client).save }.to raise_error(/Please set uri/)
    end

    it 'is a pending example' # TODO
  end

  describe '#configuration' do
    it 'requires a uri' do
      expect { OneviewSDK::Enclosure.new(@client).configuration }.to raise_error(/Please set uri/)
    end

    it 'does a PUT to /uri/configuration and updates the attributes' do
      item = OneviewSDK::Enclosure.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_put).with('/rest/fake/configuration', item.api_version).and_return(FakeResponse.new(name: 'NewName'))
      item.configuration
      expect(item['name']).to eq('NewName')
    end
  end

  describe '#refreshState' do
    it 'is a pending example' # TODO
  end

  describe '#script' do
    it 'requires a uri' do
      expect { OneviewSDK::Enclosure.new(@client).script }.to raise_error(/Please set uri/)
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
      expect { OneviewSDK::Enclosure.new(@client).environmentalConfiguration }.to raise_error(/Please set uri/)
    end

    it 'gets uri/environmentalConfiguration' do
      item = OneviewSDK::Enclosure.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with('/rest/fake/environmentalConfiguration', item.api_version).and_return(FakeResponse.new(key: 'val'))
      expect(item.environmentalConfiguration).to eq('key' => 'val')
    end
  end

  describe '#utilization' do
    it 'requires a uri' do
      expect { OneviewSDK::Enclosure.new(@client).utilization }.to raise_error(/Please set uri/)
    end

    it 'is a pending example' # TODO
  end

  describe '#updateAttribute' do
    it 'requires a uri' do
      expect { OneviewSDK::Enclosure.new(@client).updateAttribute(:op, :path, :val) }.to raise_error(/Please set uri/)
    end

    it 'does a PATCH to the enclusre uri' do
      item = OneviewSDK::Enclosure.new(@client, uri: '/rest/fake')
      data = { 'body' => [{ op: 'operation', path: '/path', value: 'val' }] }
      expect(@client).to receive(:rest_patch).with('/rest/fake', data, item.api_version).and_return(FakeResponse.new(key: 'Val'))
      expect(item.updateAttribute('operation', '/path', 'val')).to eq('key' => 'Val')
    end
  end

  describe '#refreshState' do
    context 'with invalid data' do
      it 'fails when invalid refreshState' do
        enclosure = OneviewSDK::Enclosure.new(@client, uri: '/rest/fake')
        expect { enclosure.refreshState('None') }.to raise_error(/Invalid refreshState/)
      end
    end
  end

  describe 'validations' do
    it 'only allows certain licensingIntent values' do
      expect { OneviewSDK::Enclosure.new(@client, licensingIntent: 'NotApplicable') }.to_not raise_error
      expect { OneviewSDK::Enclosure.new(@client, licensingIntent: 'OneView') }.to_not raise_error
      expect { OneviewSDK::Enclosure.new(@client, licensingIntent: 'OneViewNoiLO') }.to_not raise_error
      expect { OneviewSDK::Enclosure.new(@client, licensingIntent: 'OneViewStandard') }.to_not raise_error
      expect { OneviewSDK::Enclosure.new(@client, licensingIntent: '') }.to raise_error(/Invalid licensingIntent/)
      expect { OneviewSDK::Enclosure.new(@client, licensingIntent: 'invalid') }.to raise_error(/Invalid licensingIntent/)
    end
  end
end
