require 'spec_helper'

klass = OneviewSDK::ServerHardware
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::ServerHardware.find_by($client, 'name' => $secrets['server_hardware_ip']).first
      item.delete
    end
  end
end
