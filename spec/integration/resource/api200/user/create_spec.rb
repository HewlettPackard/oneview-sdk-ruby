require 'spec_helper'

klass = OneviewSDK::API200::User
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  include_examples 'UserCreateExample', 'integration context'
end
