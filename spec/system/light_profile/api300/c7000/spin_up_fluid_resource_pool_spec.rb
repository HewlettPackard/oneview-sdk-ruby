# System test script
# Light Profie

require 'spec_helper'

RSpec.describe 'Spin up fluid resource pool API300 C7000', system: true, sequence: 1, api_version: 300, model: 'C7000' do
  let(:current_client) { $client_300 }
  let(:storage_system_options) do
    {
      credentials: {
        ip_hostname: $secrets['storage_system1_ip'],
        username: $secrets['storage_system1_user'],
        password: $secrets['storage_system1_password']
      },
      managedDomain: 'TestDomain'
    }
  end
  include_examples 'SystemTestExample', 'system api300 context'
  include_examples 'SystemTestExample C7000', 'system api300 context'
end
