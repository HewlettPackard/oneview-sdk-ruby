require 'spec_helper'

klass = OneviewSDK::SANManager
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration context'

  describe '#create' do
    it 'can create resources' do
      item = OneviewSDK::SANManager.new($client)
      item['providerDisplayName'] = SAN_PROVIDER1_NAME
      item['connectionInfo'] = [
        {
          'name' => 'Host',
          'value' => $secrets['san_manager_ip']
        },
        {
          'name' => 'Port',
          'value' => 5989
        },
        {
          'name' => 'Username',
          'value' => $secrets['san_manager_username']
        },
        {
          'name' => 'Password',
          'value' => $secrets['san_manager_password']
        },
        {
          'name' => 'UseSsl',
          'value' => true
        }
      ]
      expect { item.add }.not_to raise_error
      expect(item['uri']).to be
    end
  end

  describe '#self.get_default_connection_info' do
    it 'Retrieve connection info for provider' do
      expect { OneviewSDK::SANManager.get_default_connection_info($client, SAN_PROVIDER1_NAME) }
    end
  end
end
