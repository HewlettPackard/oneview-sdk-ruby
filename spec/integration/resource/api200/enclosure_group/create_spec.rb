require 'spec_helper'

klass = OneviewSDK::EnclosureGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  let(:log_inter_group_class) { OneviewSDK::LogicalInterconnectGroup }

  options = { execute_with_enclosure_index: false, variant: 'C7000' }
  include_examples 'EnclosureGroupCreateExample', 'integration context', options
end
