require 'spec_helper'

klass = OneviewSDK::API200::User
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client }
  include_examples 'UserDeleteExample', 'integration context'
end
