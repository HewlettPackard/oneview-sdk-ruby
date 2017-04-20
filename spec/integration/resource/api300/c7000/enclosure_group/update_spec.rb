require 'spec_helper'

klass = OneviewSDK::API300::C7000::EnclosureGroup
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300 }
  include_examples 'EnclosureGroupUpdateExample', 'integration api300 context'
  include_examples 'EnclGroupScriptC7000Example', 'integration api300 context'
end
