require 'spec_helper'

klass = OneviewSDK::API600::Synergy::EnclosureGroup
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_600_synergy }
  include_examples 'EnclosureGroupUpdateExample', 'integration api600 context'
  include_examples 'EnclGroupScriptSynergyExample', 'integration api600 context', 600
end
