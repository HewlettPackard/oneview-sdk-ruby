require 'spec_helper'

klass = OneviewSDK::API300::Synergy::UplinkSet
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300_synergy }
  let(:li_name) { LOG_INT2_NAME }
  include_examples 'UplinkSetCreateExample', 'integration api300 context'
end
