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

      it 'validates the licensingIntent' do
        expect { OneviewSDK::ServerHardware.new(@client, licensingIntent: 'Invalid') }.to raise_error(/Invalid licensingIntent/)
      end

      it 'validates the configurationState' do
        expect { OneviewSDK::ServerHardware.new(@client, configurationState: 'Invalid') }.to raise_error(/Invalid configurationState/)
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
end
