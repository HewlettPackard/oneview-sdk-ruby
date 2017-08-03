require 'spec_helper'

klass = OneviewSDK::API500::C7000::EnclosureGroup
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api500 context'
  let(:current_client) { $client_500 }
  include_examples 'EnclosureGroupUpdateExample', 'integration api500 context'
  include_examples 'EnclGroupScriptC7000Example', 'integration api500 context'
end
