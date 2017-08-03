require 'spec_helper'

klass = OneviewSDK::API500::C7000::User
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500 }
  include_examples 'UserUpdateExample', 'integration api500 context'
end
