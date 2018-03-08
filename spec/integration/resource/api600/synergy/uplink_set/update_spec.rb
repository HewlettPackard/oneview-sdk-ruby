require 'spec_helper'

klass = OneviewSDK::API500::Synergy::UplinkSet
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500_synergy }
  let(:li_name) { LOG_INT2_NAME }
  include_examples 'UplinkSetUpdateExample', 'integration api500 context'
end
