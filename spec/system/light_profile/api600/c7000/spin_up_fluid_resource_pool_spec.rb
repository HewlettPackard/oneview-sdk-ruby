# System test script
# Light Profie

require 'spec_helper'

RSpec.describe 'Spin up fluid resource pool API600 C7000', system: true, sequence: 1, api_version: 600, model: 'C7000' do
  let(:current_client) { $client_600 }
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
  include_examples 'SystemTestExample', 'system API600 context'
  include_examples 'SystemTestExample C7000', 'system API600 context'
end
