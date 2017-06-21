require 'spec_helper'

klass = OneviewSDK::API300::C7000::UnmanagedDevice
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300 }
  include_examples 'UnmanagedDeviceCreateExample', 'integration api300 context'
end
