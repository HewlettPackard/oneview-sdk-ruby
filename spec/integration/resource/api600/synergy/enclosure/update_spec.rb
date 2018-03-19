require 'spec_helper'

klass = OneviewSDK::API600::Synergy::Enclosure
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_600_synergy }
  include_examples 'EnclosureUpdateExample', 'integration api600 context'

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API600::Synergy::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
