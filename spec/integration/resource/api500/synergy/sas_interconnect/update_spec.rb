require 'spec_helper'

klass = OneviewSDK::API500::Synergy::SASInterconnect
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500_synergy }
  include_examples 'SASInterconnectUpdateExample', 'integration api500 context'
end
