require 'spec_helper'

klass = OneviewSDK::ServerHardwareType
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the resource' do
      server_hardware = OneviewSDK::ServerHardware.find_by($client, name: $secrets['server_hardware_ip']).first
      item = OneviewSDK::ServerHardwareType.find_by($client, name: server_hardware['model'])
      item.retrieve!
      expect { item.delete }.not_to raise_error
    end
  end
end
