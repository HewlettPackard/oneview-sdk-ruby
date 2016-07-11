require 'spec_helper'

klass = OneviewSDK::ServerProfile
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration context'

  describe '#create' do
    it 'can create a basic connection-less assigned server profile' do
      item = OneviewSDK::ServerProfile.new($client, name: SERVER_PROFILE_NAME)
      target = OneviewSDK::ServerProfile.get_available_targets($client)['targets'].first
      server_hardware = OneviewSDK::ServerHardware.new($client, uri: target['serverHardwareUri'])
      item.set_server_hardware(server_hardware)
      expect { item.create }.to_not raise_error
    end

    it 'can create a basic connection-less unassigned server profile' do
      item = OneviewSDK::ServerProfile.new($client, name: SERVER_PROFILE2_NAME)
      target = OneviewSDK::ServerProfile.get_available_targets($client)['targets'].first
      server_hardware_type = OneviewSDK::ServerHardwareType.new($client, uri: target['serverHardwareTypeUri'])
      item.set_server_hardware_type(server_hardware_type)
      expect { item.create }.to_not raise_error
    end
  end
end
