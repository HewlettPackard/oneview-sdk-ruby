require 'spec_helper'

RSpec.describe OneviewSDK::ServerHardwareType, integration: true, type: DELETE, sequence: 10 do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the resource' do
      server_hardware = OneviewSDK::ServerHardware.find_by($client, name: $secrets['server_hardware_ip']).first
      item = OneviewSDK::ServerHardwareType.find_by($client, name: server_hardware['model'])
      item.retrieve!
      item.delete
    end
  end
end
