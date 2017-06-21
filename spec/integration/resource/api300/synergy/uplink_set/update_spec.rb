require 'spec_helper'

klass = OneviewSDK::API300::Synergy::UplinkSet
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300_synergy }
  let(:li_name) { LOG_INT2_NAME }
  include_examples 'UplinkSetUpdateExample', 'integration api300 context'
end
