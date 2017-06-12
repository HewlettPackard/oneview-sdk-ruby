require 'spec_helper'

klass = OneviewSDK::API500::Synergy::InternalLinkSet
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500 }
  include_examples 'InternalLinkSetUpdateExample', 'integration api500 context'
end
