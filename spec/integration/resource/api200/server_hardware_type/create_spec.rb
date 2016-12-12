require 'spec_helper'

klass = OneviewSDK::ServerHardwareType
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration context'

  describe '#create' do
    it 'should throw unavailable exception' do
      item = klass.new($client)
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  context 'when create server hardware' do
    it 'should create server hardware type' do
      options = {
        hostname: $secrets['server_hardware2_ip'],
        username: $secrets['server_hardware2_username'],
        password: $secrets['server_hardware2_password'],
        name: 'Server Hardware Type OneViewSDK Test',
        licensingIntent: 'OneView'
      }

      server_hardware = OneviewSDK::ServerHardware.new($client, options)

      expect { server_hardware.add }.to_not raise_error

      target = klass.new($client, uri: server_hardware['serverHardwareTypeUri'])

      expect(target.retrieve!).to eq(true)
    end
  end
end
