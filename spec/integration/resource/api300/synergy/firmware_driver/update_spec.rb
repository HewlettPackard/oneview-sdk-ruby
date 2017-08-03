require 'spec_helper'

RSpec.describe OneviewSDK::FirmwareDriver, integration: true, type: UPDATE do
  let(:current_client) { $client_300_synergy }
  include_examples 'FirmwareDriverUpdateExample', 'integration api300 context'
end
