require 'spec_helper'

klass = OneviewSDK::UnmanagedDevice
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  include_examples 'UnmanagedDeviceCreateExample', 'integration context'
end
