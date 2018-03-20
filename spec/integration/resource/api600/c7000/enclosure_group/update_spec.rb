require 'spec_helper'

klass = OneviewSDK::API600::C7000::EnclosureGroup
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api600 context'
  let(:current_client) { $client_600 }
  include_examples 'EnclosureGroupUpdateExample', 'integration api600 context'
  include_examples 'EnclGroupScriptC7000Example', 'integration api600 context'
end
