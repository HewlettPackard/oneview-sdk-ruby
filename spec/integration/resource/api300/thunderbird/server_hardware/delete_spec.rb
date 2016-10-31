require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::ServerHardware
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  describe '#remove' do
    it 'deletes the resource' do
      item = klass.find_by($client_300, 'name' => $secrets['server_hardware_ip']).first
      item.remove
    end

    it 'deletes the resource 2' do
      item = klass.find_by($client_300, 'name' => $secrets['rack_server_hardware_ip']).first
      item.remove
    end
  end
end
