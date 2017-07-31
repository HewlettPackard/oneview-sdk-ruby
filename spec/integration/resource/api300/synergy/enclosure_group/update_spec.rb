require 'spec_helper'

klass = OneviewSDK::API300::Synergy::EnclosureGroup
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300_synergy }
  include_examples 'EnclosureGroupUpdateExample', 'integration api300 context'
  include_examples 'EnclGroupScriptSynergyExample', 'integration api300 context', 300
end
