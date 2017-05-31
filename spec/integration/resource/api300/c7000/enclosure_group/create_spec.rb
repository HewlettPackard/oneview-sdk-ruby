require 'spec_helper'

klass = OneviewSDK::API300::C7000::EnclosureGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300 }
  let(:log_inter_group_class) { OneviewSDK::API300::C7000::LogicalInterconnectGroup }

  options = { execute_with_enclosure_index: true, variant: 'C7000' }
  include_examples 'EnclosureGroupCreateExample', 'integration api300 context', options
end
