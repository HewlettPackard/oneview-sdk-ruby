require 'spec_helper'

klass = OneviewSDK::API200::User
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client }
  include_examples 'UserUpdateExample', 'integration context'
end
