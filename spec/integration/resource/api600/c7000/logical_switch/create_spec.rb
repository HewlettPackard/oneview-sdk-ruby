require 'spec_helper'

klass = OneviewSDK::API600::C7000::LogicalSwitch
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_600 }
  let(:logical_switch_group_class) { OneviewSDK::API600::C7000::LogicalSwitchGroup }
  include_examples 'LogicalSwitchCreateExample', 'integration api600 context'
end
