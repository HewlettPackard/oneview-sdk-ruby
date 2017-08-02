# System test script
# Light Profie

require 'spec_helper'

RSpec.describe 'Spin up fluid resource pool API300 Synergy', system: true, sequence: 1, api_version: 300, model: 'Synergy' do
  let(:current_client) { $client_300_synergy }
  let(:storage_system_options) do
    {
      credentials: {
        ip_hostname: $secrets_synergy['storage_system1_ip'],
        username: $secrets_synergy['storage_system1_user'],
        password: $secrets_synergy['storage_system1_password']
      },
      managedDomain: 'TestDomain'
    }
  end
  include_examples 'SystemTestExample', 'system api300 context'
  include_examples 'SystemTestExample Synergy', 'system api300 context'
end
