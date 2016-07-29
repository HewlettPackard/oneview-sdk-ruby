require 'spec_helper'

klass = OneviewSDK::ServerHardwareType
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#remove' do
    it 'removes the resource' do
      server_hardware = OneviewSDK::ServerHardware.find_by($client, name: $secrets['server_hardware2_ip']).first
      model = server_hardware['model']
      expect { server_hardware.remove }.not_to raise_error
      item = OneviewSDK::ServerHardwareType.find_by($client, model: model).first
      expect { item.remove }.not_to raise_error
    end
  end
end
