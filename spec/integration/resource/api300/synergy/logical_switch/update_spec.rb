require 'spec_helper'

klass = OneviewSDK::API300::Synergy::LogicalSwitch
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300_synergy }
  options = { 'execute_internal_links_sets' => true }

  include_examples 'LogicalSwitchUpdateExample', 'integration api300 context', options
end
