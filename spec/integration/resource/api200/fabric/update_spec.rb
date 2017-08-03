require 'spec_helper'

RSpec.describe OneviewSDK::Fabric, integration: true, type: UPDATE do
  let(:current_client) { $client }
  include_examples 'FabricUpdateExample', 'integration context'
end
