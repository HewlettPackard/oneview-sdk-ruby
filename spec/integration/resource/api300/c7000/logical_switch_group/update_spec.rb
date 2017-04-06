require 'spec_helper'

klass = OneviewSDK::API300::C7000::LogicalSwitchGroup
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  let(:current_client) { $client_300 }
  subject(:item) { klass.find_by($client_300, name: LOG_SWI_GROUP_NAME).first }

  include_examples 'LogicalSwitchGroupUpdateExample', 'integration api300 context'

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API300::C7000::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
