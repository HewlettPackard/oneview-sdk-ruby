require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::StorageSystem
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  describe '#update' do
    it '#updating fc_network unmanaged ports' do
      storage_system = klass.new($client_300_thunderbird, 'credentials' => {})
      storage_system['credentials']['ip_hostname'] = $secrets['storage_system1_ip']
      storage_system.retrieve!

      fc_network = OneviewSDK::API300::Thunderbird::FCNetwork.find_by($client_300_thunderbird, {}).first

      storage_system.data['unmanagedPorts'].first['expectedNetworkUri'] = fc_network.data['uri']
      storage_system.update
      new_item = klass.new($client_300_thunderbird, 'credentials' => {})
      new_item['credentials']['ip_hostname'] = $secrets['storage_system1_ip']
      new_item.retrieve!
      list = new_item.data['unmanagedPorts'].select { |a| a['expectedNetworkUri'] == fc_network['uri'] }
      expect(list.empty?).to be false
    end
  end
end
