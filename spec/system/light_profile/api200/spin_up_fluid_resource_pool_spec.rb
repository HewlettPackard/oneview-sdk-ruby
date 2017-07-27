# System test script
# Light Profie

require 'spec_helper'

RSpec.describe 'OneviewSDK::API200', system: true, sequence: 1, api_version: 200, model: 'C7000' do
  let(:current_client) { $client }
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
  include_examples 'SystemTestExample', 'system context'
  include_examples 'SystemTestExample C7000', 'system context'
end
