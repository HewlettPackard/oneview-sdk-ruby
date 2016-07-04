require 'spec_helper'

klass = OneviewSDK::ServerHardwareType
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the resource' do
      server_hardware = OneviewSDK::ServerHardware.find_by($client, name: $secrets['server_hardware2_ip']).first
      model = server_hardware['model']
      expect { server_hardware.delete }.not_to raise_error
      item = OneviewSDK::ServerHardwareType.find_by($client, model: model).first
      expect { item.delete }.not_to raise_error
    end
  end
end
