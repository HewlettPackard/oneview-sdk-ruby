require 'spec_helper'

RSpec.describe OneviewSDK::ServerHardware, integration: true, type: DELETE, sequence: 9 do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::ServerHardware.find_by($client, 'name' => $secrets['server_hardware_ip']).first
      item.delete
    end
  end
end
