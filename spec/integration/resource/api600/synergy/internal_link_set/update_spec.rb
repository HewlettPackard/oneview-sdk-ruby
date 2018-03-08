require 'spec_helper'

klass = OneviewSDK::API600::Synergy::InternalLinkSet
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_600 }
  include_examples 'InternalLinkSetUpdateExample', 'integration api600 context'
end
