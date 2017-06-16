require 'spec_helper'

klass = OneviewSDK::API500::C7000::UplinkSet
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500 }
  let(:li_name) { LOG_INT_NAME }
  include_examples 'UplinkSetUpdateExample', 'integration api500 context'
end
