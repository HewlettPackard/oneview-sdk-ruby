require 'spec_helper'

klass = OneviewSDK::API600::C7000::UplinkSet
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_600 }
  let(:li_name) { LOG_INT_NAME }
  include_examples 'UplinkSetUpdateExample', 'integration api600 context'
end
