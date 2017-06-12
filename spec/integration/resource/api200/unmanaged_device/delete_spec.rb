require 'spec_helper'

klass = OneviewSDK::UnmanagedDevice
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client }
  include_examples 'UnmanagedDeviceDeleteExample', 'integration context'
end
