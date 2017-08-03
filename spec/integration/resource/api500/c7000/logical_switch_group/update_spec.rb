require 'spec_helper'

klass = OneviewSDK::API500::C7000::LogicalSwitchGroup
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api500 context'

  let(:current_client) { $client_500 }
  subject(:item) { klass.find_by($client_500, name: LOG_SWI_GROUP_NAME).first }

  include_examples 'LogicalSwitchGroupUpdateExample', 'integration api500 context'

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API500::C7000::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
