require 'spec_helper'

RSpec.describe OneviewSDK::FirmwareDriver, integration: true, type: UPDATE do
  let(:current_client) { $client }
  include_examples 'FirmwareDriverUpdateExample', 'integration context'
end
