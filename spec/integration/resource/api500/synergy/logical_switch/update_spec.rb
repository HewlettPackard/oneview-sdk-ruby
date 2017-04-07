require 'spec_helper'

klass = OneviewSDK::API500::Synergy::LogicalSwitch
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500_synergy }
  options = { 'execute_internal_links_sets' => true }

  include_examples 'LogicalSwitchUpdateExample', 'integration api500 context', options
end
