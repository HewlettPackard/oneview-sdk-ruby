require 'spec_helper'

klass = OneviewSDK::API500::C7000::Enclosure
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500 }
  include_examples 'EnclosureUpdateExample', 'integration api500 context'

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API500::C7000::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
