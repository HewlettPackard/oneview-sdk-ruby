require 'spec_helper'

klass = OneviewSDK::Switch
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  let(:item) { klass.find_by(current_client, name: $secrets['logical_switch1_ip']).first }

  include_examples 'SwitchCreateExample', 'integration context', true
end
