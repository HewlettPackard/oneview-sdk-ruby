require 'spec_helper'

klass = OneviewSDK::API600::C7000::LogicalSwitchGroup
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api600 context'

  let(:current_client) { $client_600 }
  subject(:item) { klass.find_by($client_600, name: LOG_SWI_GROUP_NAME).first }

  include_examples 'LogicalSwitchGroupUpdateExample', 'integration api600 context'
end
