require 'spec_helper'

klass = OneviewSDK::API300::Synergy::EnclosureGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300_synergy }
  let(:log_inter_group_class) { OneviewSDK::API300::Synergy::LogicalInterconnectGroup }

  options = { execute_with_enclosure_index: true, variant: 'Synergy' }
  include_examples 'EnclosureGroupCreateExample', 'integration api300 context', options
end
