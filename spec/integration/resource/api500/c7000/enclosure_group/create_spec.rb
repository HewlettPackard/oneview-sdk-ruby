require 'spec_helper'

klass = OneviewSDK::API500::C7000::EnclosureGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500 }
  let(:log_inter_group_class) { OneviewSDK::API500::C7000::LogicalInterconnectGroup }

  options = { execute_with_enclosure_index: true, variant: 'C7000' }
  include_examples 'EnclosureGroupCreateExample', 'integration api500 context', options
end
