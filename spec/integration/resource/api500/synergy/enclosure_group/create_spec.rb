require 'spec_helper'

klass = OneviewSDK::API500::Synergy::EnclosureGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500_synergy }
  let(:log_inter_group_class) { OneviewSDK::API500::Synergy::LogicalInterconnectGroup }

  options = { execute_with_enclosure_index: true, variant: 'Synergy' }
  include_examples 'EnclosureGroupCreateExample', 'integration api500 context', options
end
