require 'spec_helper'

RSpec.describe OneviewSDK::Switch, integration: true, type: UPDATE do
  let(:current_client) { $client }
  include_examples 'SwitchUpdateExample', 'integration context'
end
