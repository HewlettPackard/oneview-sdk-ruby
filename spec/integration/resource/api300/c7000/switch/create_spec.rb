require 'spec_helper'

klass = OneviewSDK::API300::C7000::Switch
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300 }
  let(:item) { described_class.find_by(current_client, name: $secrets['logical_switch1_ip']).first }

  include_examples 'SwitchCreateExample', 'integration api300 context', true
end
