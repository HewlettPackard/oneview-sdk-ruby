require 'spec_helper'

klass = OneviewSDK::API500::C7000::LogicalSwitch
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500 }
  options = { 'execute_internal_links_sets' => true, 'execute_refresh' => true }

  include_examples 'LogicalSwitchUpdateExample', 'integration api500 context', options

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API500::C7000::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
