require 'spec_helper'

RSpec.describe OneviewSDK::EnclosureGroup, integration: true, type: UPDATE do
  let(:current_client) { $client }
  include_examples 'EnclosureGroupUpdateExample', 'integration context'
  include_examples 'EnclGroupScriptC7000Example', 'integration context'
end
