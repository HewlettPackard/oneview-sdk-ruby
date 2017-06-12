require 'spec_helper'

klass = OneviewSDK::API300::C7000::InternalLinkSet
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_examples 'InternalLinkSetCreateExample', 'integration api300 context' do
    let(:current_client) { $client_300 }
  end
end
