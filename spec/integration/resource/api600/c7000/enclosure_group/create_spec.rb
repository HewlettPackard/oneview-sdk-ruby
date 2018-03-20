require 'spec_helper'

klass = OneviewSDK::API600::C7000::EnclosureGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_600 }
  let(:log_inter_group_class) { OneviewSDK::API600::C7000::LogicalInterconnectGroup }

  options = { execute_with_enclosure_index: true, variant: 'C7000' }
  include_examples 'EnclosureGroupCreateExample', 'integration api600 context', options
end
