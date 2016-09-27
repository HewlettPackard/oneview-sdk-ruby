require 'spec_helper'

RSpec.describe OneviewSDK::API300::ServerHardware do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::ServerHardware
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      server_hardware = OneviewSDK::API300::ServerHardware.new(@client_300)
      expect(server_hardware[:type]).to eq('server-hardware-4')
    end
  end

  describe '#update_ilo_firmware' do
    it '' do
      item = OneviewSDK::API300::ServerHardware.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_put).with(item['uri'] + '/mpFirmwareVersion')
        .and_return(FakeResponse.new({}))
      item.update_ilo_firmware
    end
  end

  describe '#get_bios' do
    it '' do
      item = OneviewSDK::API300::ServerHardware.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with(item['uri'] + '/bios')
        .and_return(FakeResponse.new({}))
      item.get_bios
    end
  end

  describe '#get_remote_console_url' do
    it '' do
      item = OneviewSDK::API300::ServerHardware.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with(item['uri'] + '/remoteConsoleUrl')
        .and_return(FakeResponse.new({}))
      item.get_remote_console_url
    end
  end

  describe '#get_ilo_sso_url' do
    it '' do
      item = OneviewSDK::API300::ServerHardware.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with(item['uri'] + '/iloSsoUrl')
        .and_return(FakeResponse.new({}))
      item.get_ilo_sso_url
    end
  end

  describe '#get_java_remote_sso_url' do
    it '' do
      item = OneviewSDK::API300::ServerHardware.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with(item['uri'] + '/javaRemoteConsoleUrl')
        .and_return(FakeResponse.new({}))
      item.get_java_remote_sso_url
    end
  end

  describe '#set_refresh_state' do
    it 'requires a uri' do
      expect { OneviewSDK::API300::ServerHardware.new(@client_300).set_refresh_state(:state) }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a PUT to /refreshState' do
      item = OneviewSDK::API300::ServerHardware.new(@client_300, uri: '/rest/fake', refreshState: 'NotRefreshing')
      expect(@client_300).to receive(:rest_put).with(item['uri'] + '/refreshState', Hash, item.api_version)
        .and_return(FakeResponse.new(refreshState: 'Refreshing'))
      item.set_refresh_state('Refreshing')
      expect(item['refreshState']).to eq('Refreshing')
    end

    it 'allows string or symbol refreshState values' do
      item = OneviewSDK::API300::ServerHardware.new(@client_300, uri: '/rest/fake', refreshState: 'NotRefreshing')
      expect(@client_300).to receive(:rest_put).with(item['uri'] + '/refreshState', Hash, item.api_version)
        .and_return(FakeResponse.new(refreshState: 'Refreshing'))
      item.set_refresh_state(:Refreshing)
      expect(item['refreshState']).to eq('Refreshing')
    end
  end

  describe '#environmentalConfiguration' do
    it 'requires a uri' do
      expect { OneviewSDK::API300::ServerHardware.new(@client_300).environmental_configuration }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'gets uri/environmentalConfiguration' do
      item = OneviewSDK::API300::ServerHardware.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with('/rest/fake/environmentalConfiguration', item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      expect(item.environmental_configuration).to eq('key' => 'val')
    end
  end

  describe '#utilization' do
    it 'requires a uri' do
      expect { OneviewSDK::API300::ServerHardware.new(@client_300).utilization }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'gets uri/utilization' do
      item = OneviewSDK::API300::ServerHardware.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with('/rest/fake/utilization', item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      expect(item.utilization).to eq('key' => 'val')
    end

    it 'takes query parameters' do
      item = OneviewSDK::API300::ServerHardware.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with('/rest/fake/utilization?key=val', item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      expect(item.utilization(key: :val)).to eq('key' => 'val')
    end

    it 'takes an array for the :fields query parameter' do
      item = OneviewSDK::API300::ServerHardware.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with('/rest/fake/utilization?fields=one,two,three', item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      expect(item.utilization(fields: %w(one two three))).to eq('key' => 'val')
    end

    it 'converts Time query parameters' do
      t = Time.now
      item = OneviewSDK::API300::ServerHardware.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with("/rest/fake/utilization?filter=startDate=#{t.utc.iso8601(3)}", item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      expect(item.utilization(startDate: t)).to eq('key' => 'val')
    end
  end

  describe '#add' do
    context 'with valid data' do
      before :each do
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_api).and_return(true)
        allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler)
          .and_return(name: 'En1OA1,bay 1', serialNumber: 'Fake', uri: '/rest/fake')

        @data = {
          'hostname' => '1.1.1.1',
          'username' => 'Admin',
          'password' => 'secret123',
          'licensingIntent' => 'OneView',
          'force' => true,
          'other' => 'blah'
        }
        @server_hardware = OneviewSDK::API300::ServerHardware.new(@client_300, @data)
      end

      it 'only sends certain attributes on the POST' do
        data = @data.select { |k, _v| k != 'other' }
        expect(@client_300).to receive(:rest_post).with('/rest/server-hardware', { 'body' => data }, anything)
        @server_hardware.add
      end
    end

    context 'with invalid data' do
      it 'fails when certain attributes are not set' do
        server_hardware = OneviewSDK::API300::ServerHardware.new(@client_300, {})
        expect { server_hardware.add }.to raise_error(OneviewSDK::IncompleteResource, /Missing required attribute/)
      end
    end
  end

  describe '#power_on' do
    it 'calls #set_power_state' do
      item = OneviewSDK::API300::ServerHardware.new(@client_300)
      expect(item).to receive(:set_power_state).with('on', false).and_return(true)
      item.power_on
    end

    it 'passes the force value' do
      item = OneviewSDK::API300::ServerHardware.new(@client_300)
      expect(item).to receive(:set_power_state).with('on', true).and_return(true)
      item.power_on(true)
    end
  end

  describe '#power_off' do
    it 'calls #set_power_state' do
      item = OneviewSDK::API300::ServerHardware.new(@client_300)
      expect(item).to receive(:set_power_state).with('off', false).and_return(true)
      item.power_off
    end

    it 'passes the force value' do
      item = OneviewSDK::API300::ServerHardware.new(@client_300)
      expect(item).to receive(:set_power_state).with('off', true).and_return(true)
      item.power_off(true)
    end
  end

  describe '#set_power_state' do
    before :each do
      @item = OneviewSDK::API300::ServerHardware.new(@client_300, uri: '/rest/fake', powerState: 'on')
      @item2 = OneviewSDK::API300::ServerHardware.new(@client_300, uri: '/rest/fake', powerState: 'off')
      allow_any_instance_of(OneviewSDK::API300::ServerHardware).to receive(:refresh).and_return(true)
    end

    it 'returns true if the state is the same' do
      expect(@item.power_on).to eq(true)
      expect(@item2.power_off).to eq(true)
    end

    it 'does a PUT to uri/powerState and updates @data' do
      expect(@client_300).to receive(:rest_put)
        .with(@item['uri'] + '/powerState', 'body' => { powerState: 'Off', powerControl: 'MomentaryPress' })
        .and_return(FakeResponse.new(powerState: 'Off'))
      expect(@item.power_off).to eq(true)
      expect(@item['powerState']).to eq('Off')
    end

    it 'powering on does a ColdBoot for servers in an Unknown state' do
      @item['powerState'] = 'Unknown'
      expect(@client_300).to receive(:rest_put)
        .with(@item['uri'] + '/powerState', 'body' => { powerState: 'On', powerControl: 'ColdBoot' })
        .and_return(FakeResponse.new(powerState: 'On'))
      expect(@item.power_on).to eq(true)
      expect(@item['powerState']).to eq('On')
    end

    it 'powering off does a PressAndHold for servers in an Unknown state' do
      @item['powerState'] = 'Unknown'
      expect(@client_300).to receive(:rest_put)
        .with(@item['uri'] + '/powerState', 'body' => { powerState: 'Off', powerControl: 'PressAndHold' })
        .and_return(FakeResponse.new(powerState: 'Off'))
      expect(@item.power_off).to eq(true)
      expect(@item['powerState']).to eq('Off')
    end

    it 'powering off does a PressAndHold for servers in a Resetting state' do
      @item['powerState'] = 'Resetting'
      expect(@client_300).to receive(:rest_put)
        .with(@item['uri'] + '/powerState', 'body' => { powerState: 'Off', powerControl: 'PressAndHold' })
        .and_return(FakeResponse.new(powerState: 'Off'))
      expect(@item.power_off).to eq(true)
      expect(@item['powerState']).to eq('Off')
    end
  end


  describe 'undefined methods' do
    it 'does not allow the create action' do
      server_hardware = OneviewSDK::API300::ServerHardware.new(@client_300)
      expect { server_hardware.create }.to raise_error(
        OneviewSDK::MethodUnavailable,
        /The method #create is unavailable for this resource/
      )
    end

    it 'does not allow the update action' do
      server_hardware = OneviewSDK::API300::ServerHardware.new(@client_300)
      expect { server_hardware.update }.to raise_error(
        OneviewSDK::MethodUnavailable,
        /The method #update is unavailable for this resource/
      )
    end

    it 'does not allow the delete action' do
      server_hardware = OneviewSDK::API300::ServerHardware.new(@client_300)
      expect { server_hardware.delete }.to raise_error(
        OneviewSDK::MethodUnavailable,
        /The method #delete is unavailable for this resource/
      )
    end
  end
end
