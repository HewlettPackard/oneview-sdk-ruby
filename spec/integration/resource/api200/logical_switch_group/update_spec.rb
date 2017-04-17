require 'spec_helper'

klass = OneviewSDK::LogicalSwitchGroup
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration context'

  let(:current_client) { $client }
  subject(:item) { klass.find_by($client, name: LOG_SWI_GROUP_NAME).first }

  include_examples 'LogicalSwitchGroupUpdateExample', 'integration context'
end
