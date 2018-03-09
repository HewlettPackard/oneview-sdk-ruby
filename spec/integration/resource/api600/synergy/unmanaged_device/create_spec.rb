require 'spec_helper'

klass = OneviewSDK::API500::Synergy::UnmanagedDevice
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500_synergy }
  include_examples 'UnmanagedDeviceCreateExample', 'integration api500 context'
end
