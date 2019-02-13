# System test script
# Light Profie

require 'spec_helper'

RSpec.describe 'Clean up fluid resource pool API800 C7000', system: true, sequence: 1, api_version: 800, model: 'C7000' do
  let(:current_client) { $client_800 }
  let(:storage_system_options) do
    {
      credentials: {
        username: $secrets['storage_system1_user'],
        password: $secrets['storage_system1_password']
      },
      hostname: $secrets['storage_system1_ip'],
      family: 'StoreServ',
      deviceSpecificAttributes: {
        managedDomain: 'TestDomain'
      }
    }
  end

  let(:storage_virtual_system_options) do
    {
      credentials: {
        username: $secrets['store_virtual_user'],
        password: $secrets['store_virtual_password']
      },
      hostname: $secrets['store_virtual_ip'],
      family: 'StoreVirtual'
    }
  end
  include_examples 'Clean up SystemTestExample', 'system api800 context'
  include_examples 'Clean up SystemTestExample C7000', 'system api800 context'
end
