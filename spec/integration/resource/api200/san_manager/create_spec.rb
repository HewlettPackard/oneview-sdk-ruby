require 'spec_helper'

klass = OneviewSDK::SANManager
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  let(:provider_name) { SAN_PROVIDER1_NAME }

  include_examples 'ConnectionInfoC7000'
  include_examples 'SANManagerCreateExample', 'integration context'
end
