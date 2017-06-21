require 'spec_helper'

klass = OneviewSDK::API500::C7000::LogicalSwitch
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500 }
  let(:logical_switch_group_class) { OneviewSDK::API500::C7000::LogicalSwitchGroup }
  include_examples 'LogicalSwitchCreateExample', 'integration api500 context'
end
