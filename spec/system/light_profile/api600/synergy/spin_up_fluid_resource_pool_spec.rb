# System test script
# Light Profie

require 'spec_helper'

RSpec.describe 'Spin up fluid resource pool API600 Synergy', system: true, sequence: 1, api_version: 600, model: 'Synergy' do
  let(:current_client) { $client_600_synergy }
  let(:storage_system_options) do
    {
      credentials: {
        username: $secrets_synergy['storage_system1_user'],
        password: $secrets_synergy['storage_system1_password']
      },
      hostname: $secrets_synergy['storage_system1_ip'],
      family: 'StoreServ',
      deviceSpecificAttributes: {
        managedDomain: 'TestDomain'
      }
    }
  end

  let(:storage_virtual_system_options) do
    {
      credentials: {
        username: $secrets_synergy['store_virtual_user'],
        password: $secrets_synergy['store_virtual_password']
      },
      hostname: $secrets_synergy['store_virtual_ip'],
      family: 'StoreVirtual',
      name: 'StoreVirtual Name'
    }
  end
  include_examples 'SystemTestExample', 'system api600 context'
  include_examples 'SystemTestExample Synergy', 'system api600 context'
end
