require 'spec_helper'

klass = OneviewSDK::API600::Synergy::EnclosureGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_600_synergy }
  let(:log_inter_group_class) { OneviewSDK::API600::Synergy::LogicalInterconnectGroup }

  options = { execute_with_enclosure_index: true, variant: 'Synergy' }
  include_examples 'EnclosureGroupCreateExample', 'integration api600 context', options
end
