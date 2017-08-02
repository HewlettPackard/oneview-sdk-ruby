require 'spec_helper'

klass = OneviewSDK::StorageSystem
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_examples 'StorageSystemCreateExample', 'integration context', 200 do
    let(:current_client) { $client }
    let(:item_attributes) do
      {
        credentials: {
          ip_hostname: $secrets['storage_system1_ip'],
          username: $secrets['storage_system1_user'],
          password: $secrets['storage_system1_password']
        },
        managedDomain: 'TestDomain'
      }
    end
  end
end
