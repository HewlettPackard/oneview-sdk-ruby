require 'spec_helper'

klass = OneviewSDK::LoginDetail
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }

  include_examples 'LoginDetailGetExample', 'integration context'
end
