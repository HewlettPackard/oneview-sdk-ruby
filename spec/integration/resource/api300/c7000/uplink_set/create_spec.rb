require 'spec_helper'

klass = OneviewSDK::API300::C7000::UplinkSet
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300 }
  let(:li_name) { LOG_INT_NAME }
  include_examples 'UplinkSetCreateExample', 'integration api300 context'
end
