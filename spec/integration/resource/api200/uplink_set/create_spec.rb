require 'spec_helper'

klass = OneviewSDK::UplinkSet
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  let(:li_name) { LOG_INT_NAME }
  include_examples 'UplinkSetCreateExample', 'integration context'
end
