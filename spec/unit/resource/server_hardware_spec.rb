require 'spec_helper'

RSpec.describe OneviewSDK::ServerHardware do
  include_context 'shared context'

  describe '#initialize' do
    context 'with OneView 1.2' do
      it 'sets the defaults correctly' do
        server_hardware = OneviewSDK::ServerHardware.new(@client_120)
        expect(server_hardware[:type]).to eq('server-hardware-3')
      end
    end

    context 'with OneView 2.0' do
      it 'sets the defaults correctly' do
        server_hardware = OneviewSDK::ServerHardware.new(@client)
        expect(server_hardware[:type]).to eq('server-hardware-4')
      end
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

  describe '#save' do
    it 'does not allow it' do
      server_hardware = OneviewSDK::ServerHardware.new(@client, {})
      expect { server_hardware.save }.to output(/cannot be updated/).to_stdout_from_any_process
    end
  end

  describe '#update' do
    it 'does not allow it' do
      server_hardware = OneviewSDK::ServerHardware.new(@client, {})
      expect { server_hardware.update(name: 'new') }.to output(/cannot be updated/).to_stdout_from_any_process
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
      %w(OneView OneViewNoiLO OneViewStandard).each do |v|
        expect { OneviewSDK::ServerHardware.new(@client, licensingIntent: v) }.to_not raise_error
      end
      expect { OneviewSDK::ServerHardware.new(@client, licensingIntent: '') }.to raise_error(/Invalid licensingIntent/)
      expect { OneviewSDK::ServerHardware.new(@client, licensingIntent: 'Invalid') }.to raise_error(/Invalid licensingIntent/)
    end

    it 'only allows certain configurationState values' do
      %w(Managed Monitored).each do |v|
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
