require 'spec_helper'

klass = OneviewSDK::API300::Synergy::SASLogicalInterconnect
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300_synergy }
  let(:firmware_driver_class) { OneviewSDK::API300::Synergy::FirmwareDriver }

  include_examples 'SASLogicalInterconnectUpdateExample', 'integration api300 context'
end
