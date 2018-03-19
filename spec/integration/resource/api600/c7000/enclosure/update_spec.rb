require 'spec_helper'

klass = OneviewSDK::API600::C7000::Enclosure
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_600 }
  include_examples 'EnclosureUpdateExample', 'integration api600 context'

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API600::C7000::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
