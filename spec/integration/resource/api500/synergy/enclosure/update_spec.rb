require 'spec_helper'

klass = OneviewSDK::API500::Synergy::Enclosure
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500_synergy }
  include_examples 'EnclosureUpdateExample', 'integration api500 context'

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API500::Synergy::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
