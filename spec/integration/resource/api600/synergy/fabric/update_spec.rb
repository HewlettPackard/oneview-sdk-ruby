require 'spec_helper'

klass = OneviewSDK::API500::Synergy::Fabric
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500_synergy }
  include_examples 'FabricUpdateExample', 'integration api500 context'
end
