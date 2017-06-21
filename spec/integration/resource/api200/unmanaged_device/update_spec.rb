require 'spec_helper'

RSpec.describe OneviewSDK::UnmanagedDevice, integration: true, type: UPDATE do
  let(:current_client) { $client }
  include_examples 'UnmanagedDeviceUpdateExample', 'integration context'
end
