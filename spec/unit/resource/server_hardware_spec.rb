require 'spec_helper'

RSpec.describe OneviewSDK::ServerHardware do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      server_hardware = OneviewSDK::ServerHardware.new(@client)
      expect(server_hardware[:type]).to eq('server-hardware-4')
    end
  end

  describe '#update_ilo_firmware' do
    it '' do
      item = OneviewSDK::ServerHardware.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_put).with(item['uri'] + '/mpFirwareVersion')
        .and_return(FakeResponse.new({}))
      item.update_ilo_firmware
    end
  end

  describe '#get_bios' do
    it '' do
      item = OneviewSDK::ServerHardware.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with(item['uri'] + '/bios')
        .and_return(FakeResponse.new({}))
      item.get_bios
    end
  end

  describe '#get_remote_console_url' do
    it '' do
      item = OneviewSDK::ServerHardware.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with(item['uri'] + '/remoteConsoleUrl')
        .and_return(FakeResponse.new({}))
      item.get_remote_console_url
    end
  end

  describe '#get_ilo_sso_url' do
    it '' do
      item = OneviewSDK::ServerHardware.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with(item['uri'] + '/iloSsoUrl')
        .and_return(FakeResponse.new({}))
      item.get_ilo_sso_url
    end
  end

  describe '#get_java_remote_sso_url' do
    it '' do
      item = OneviewSDK::ServerHardware.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with(item['uri'] + '/javaRemoteSsoUrl')
        .and_return(FakeResponse.new({}))
      item.get_java_remote_sso_url
    end
  end

  describe '#set_refresh_state' do
    it 'requires a uri' do
      expect { OneviewSDK::ServerHardware.new(@client).set_refresh_state(:state) }.to raise_error(/Please set uri/)
    end

    it 'only permits certain states' do
      allow(@client).to receive(:rest_put).and_return(FakeResponse.new)

      OneviewSDK::ServerHardware::VALID_REFRESH_STATES.each do |i|
        expect { OneviewSDK::Enclosure.new(@client, uri: '/rest/fake').set_refresh_state(i) }.to_not raise_error
      end
      expect { OneviewSDK::ServerHardware.new(@client, uri: '/rest/fake').set_refresh_state('') }.to raise_error(/Invalid refreshState/)
      expect { OneviewSDK::ServerHardware.new(@client, uri: '/rest/fake').set_refresh_state('state') }.to raise_error(/Invalid refreshState/)
      expect { OneviewSDK::ServerHardware.new(@client, uri: '/rest/fake').set_refresh_state(nil) }.to raise_error(/Invalid refreshState/)
    end

    it 'does a PUT to /refreshState' do
      item = OneviewSDK::ServerHardware.new(@client, uri: '/rest/fake', refreshState: 'NotRefreshing')
      expect(@client).to receive(:rest_put).with(item['uri'] + '/refreshState', Hash, item.api_version)
        .and_return(FakeResponse.new(refreshState: 'Refreshing'))
      item.set_refresh_state('Refreshing')
      expect(item['refreshState']).to eq('Refreshing')
    end

    it 'allows string or symbol refreshState values' do
      item = OneviewSDK::ServerHardware.new(@client, uri: '/rest/fake', refreshState: 'NotRefreshing')
      expect(@client).to receive(:rest_put).with(item['uri'] + '/refreshState', Hash, item.api_version)
        .and_return(FakeResponse.new(refreshState: 'Refreshing'))
      item.set_refresh_state(:Refreshing)
      expect(item['refreshState']).to eq('Refreshing')
    end
  end

  describe '#environmentalConfiguration' do
    it 'requires a uri' do
      expect { OneviewSDK::ServerHardware.new(@client).environmental_configuration }.to raise_error(/Please set uri/)
    end

    it 'gets uri/environmentalConfiguration' do
      item = OneviewSDK::ServerHardware.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with('/rest/fake/environmentalConfiguration', item.api_version).and_return(FakeResponse.new(key: 'val'))
      expect(item.environmental_configuration).to eq('key' => 'val')
    end
  end

  describe '#utilization' do
    it 'requires a uri' do
      expect { OneviewSDK::ServerHardware.new(@client).utilization }.to raise_error(/Please set uri/)
    end

    it 'gets uri/utilization' do
      item = OneviewSDK::ServerHardware.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with('/rest/fake/utilization', item.api_version).and_return(FakeResponse.new(key: 'val'))
      expect(item.utilization).to eq('key' => 'val')
    end

    it 'takes query parameters' do
      item = OneviewSDK::ServerHardware.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with('/rest/fake/utilization?key=val', item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      expect(item.utilization(key: :val)).to eq('key' => 'val')
    end

    it 'takes an array for the :fields query parameter' do
      item = OneviewSDK::ServerHardware.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with('/rest/fake/utilization?fields=one,two,three', item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      expect(item.utilization(fields: %w(one two three))).to eq('key' => 'val')
    end

    it 'converts Time query parameters' do
      t = Time.now
      item = OneviewSDK::ServerHardware.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with("/rest/fake/utilization?filter=startDate=#{t.utc.iso8601(3)}", item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      expect(item.utilization(startDate: t)).to eq('key' => 'val')
    end
  end

  describe '#create' do
    context 'with valid data' do
      before :each do
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_api).and_return(true)
        allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(
          name: 'En1OA1,bay 1', serialNumber: 'Fake', uri: '/rest/fake')

        @data = {
          'hostname' => '1.1.1.1',
          'username' => 'Admin',
          'password' => 'secret123',
          'licensingIntent' => 'OneView',
          'force' => true,
          'other' => 'blah'
        }
        @server_hardware = OneviewSDK::ServerHardware.new(@client, @data)
      end

      it 'only sends certain attributes on the POST' do
        data = @data.select { |k, _v| k != 'other' }
        expect(@client).to receive(:rest_post).with('/rest/server-hardware', { 'body' => data }, anything)
        @server_hardware.create
      end
    end

    context 'with invalid data' do
      it 'fails when certain attributes are not set' do
        server_hardware = OneviewSDK::ServerHardware.new(@client, {})
        expect { server_hardware.create }.to raise_error(/Missing required attribute/)
      end
    end
  end

  describe '#update' do
    it 'does not allow it' do
      server_hardware = OneviewSDK::ServerHardware.new(@client, {})
      expect { server_hardware.update(name: 'new') }.to raise_error(/The method #update is unavailable for this resource/)
      expect(server_hardware[:name]).to be_nil
    end
  end

  describe '#power_on' do
    it 'calls #set_power_state' do
      item = OneviewSDK::ServerHardware.new(@client)
      expect(item).to receive(:set_power_state).with('on', false).and_return(true)
      item.power_on
    end

    it 'passes the force value' do
      item = OneviewSDK::ServerHardware.new(@client)
      expect(item).to receive(:set_power_state).with('on', true).and_return(true)
      item.power_on(true)
    end
  end

  describe '#power_off' do
    it 'calls #set_power_state' do
      item = OneviewSDK::ServerHardware.new(@client)
      expect(item).to receive(:set_power_state).with('off', false).and_return(true)
      item.power_off
    end

    it 'passes the force value' do
      item = OneviewSDK::ServerHardware.new(@client)
      expect(item).to receive(:set_power_state).with('off', true).and_return(true)
      item.power_off(true)
    end
  end

  describe 'validations' do
    it 'only allows certain licensingIntent values' do
      described_class::VALID_LICENSING_INTENTS.each do |v|
        expect { OneviewSDK::ServerHardware.new(@client, licensingIntent: v) }.to_not raise_error
      end
      expect { OneviewSDK::ServerHardware.new(@client, licensingIntent: '') }.to raise_error(/Invalid licensingIntent/)
      expect { OneviewSDK::ServerHardware.new(@client, licensingIntent: 'Invalid') }.to raise_error(/Invalid licensingIntent/)
    end

    it 'only allows certain configurationState values' do
      described_class::VALID_CONFIGURATION_STATES.each do |v|
        expect { OneviewSDK::ServerHardware.new(@client, configurationState: v) }.to_not raise_error
      end
      expect { OneviewSDK::ServerHardware.new(@client, configurationState: '') }.to raise_error(/Invalid configurationState/)
      expect { OneviewSDK::ServerHardware.new(@client, configurationState: 'Invalid') }.to raise_error(/Invalid configurationState/)
    end
  end

  describe '#set_power_state' do
    before :each do
      @item = OneviewSDK::ServerHardware.new(@client, uri: '/rest/fake', powerState: 'on')
      @item2 = OneviewSDK::ServerHardware.new(@client, uri: '/rest/fake', powerState: 'off')
      allow_any_instance_of(OneviewSDK::ServerHardware).to receive(:refresh).and_return(true)
    end

    it 'returns true if the state is the same' do
      expect(@item.power_on).to eq(true)
      expect(@item2.power_off).to eq(true)
    end

    it 'does a PUT to uri/powerState and updates @data' do
      expect(@client).to receive(:rest_put).with(@item['uri'] + '/powerState', 'body' => { powerState: 'Off', powerControl: 'MomentaryPress' })
        .and_return(FakeResponse.new(powerState: 'Off'))
      expect(@item.power_off).to eq(true)
      expect(@item['powerState']).to eq('Off')
    end

    it 'powering on does a ColdBoot for servers in an Unknown state' do
      @item['powerState'] = 'Unknown'
      expect(@client).to receive(:rest_put).with(@item['uri'] + '/powerState', 'body' => { powerState: 'On', powerControl: 'ColdBoot' })
        .and_return(FakeResponse.new(powerState: 'On'))
      expect(@item.power_on).to eq(true)
      expect(@item['powerState']).to eq('On')
    end

    it 'powering off does a PressAndHold for servers in an Unknown state' do
      @item['powerState'] = 'Unknown'
      expect(@client).to receive(:rest_put).with(@item['uri'] + '/powerState', 'body' => { powerState: 'Off', powerControl: 'PressAndHold' })
        .and_return(FakeResponse.new(powerState: 'Off'))
      expect(@item.power_off).to eq(true)
      expect(@item['powerState']).to eq('Off')
    end

    it 'powering off does a PressAndHold for servers in a Resetting state' do
      @item['powerState'] = 'Resetting'
      expect(@client).to receive(:rest_put).with(@item['uri'] + '/powerState', 'body' => { powerState: 'Off', powerControl: 'PressAndHold' })
        .and_return(FakeResponse.new(powerState: 'Off'))
      expect(@item.power_off).to eq(true)
      expect(@item['powerState']).to eq('Off')
    end
  end
end
