require 'spec_helper'

klass = OneviewSDK::API300::C7000::LogicalSwitch
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300 }
  options = { 'execute_internal_links_sets' => true, 'execute_refresh' => true }

  include_examples 'LogicalSwitchUpdateExample', 'integration api300 context', options

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API300::C7000::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
