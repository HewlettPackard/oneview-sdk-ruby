require 'spec_helper'

klass = OneviewSDK::API300::C7000::UplinkSet
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300 }
  let(:li_name) { LOG_INT_NAME }
  include_examples 'UplinkSetUpdateExample', 'integration api300 context'
end
