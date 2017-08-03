require 'spec_helper'

klass = OneviewSDK::API500::Synergy::EnclosureGroup
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500_synergy }
  include_examples 'EnclosureGroupUpdateExample', 'integration api500 context'
  include_examples 'EnclGroupScriptSynergyExample', 'integration api500 context', 500
end
