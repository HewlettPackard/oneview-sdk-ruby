require 'spec_helper'

klass = OneviewSDK::StorageSystem
RSpec.describe klass, integration: true, type: UPDATE do
  include_examples 'StorageSystemUpdateExample', 'integration context', 200 do
    let(:current_client) { $client }
    let(:item_attributes) do
      {
        credentials: {
          username: $secrets['storage_system1_user'],
          password: $secrets['storage_system1_password'],
          ip_hostname: $secrets['storage_system1_ip']
        }
      }
    end
  end
end
