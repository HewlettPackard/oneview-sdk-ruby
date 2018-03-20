require 'spec_helper'

klass = OneviewSDK::API600::Synergy::SASLogicalInterconnect
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_600_synergy }
  let(:firmware_driver_class) { OneviewSDK::API600::Synergy::FirmwareDriver }

  include_examples 'SASLogicalInterconnectUpdateExample', 'integration api600 context'
end
