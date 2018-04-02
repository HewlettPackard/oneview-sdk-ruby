require 'spec_helper'

klass = OneviewSDK::API600::C7000::ServerProfile
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_600 }
  include_examples 'ServerProfileDeleteExample', 'integration api600 context'
end
