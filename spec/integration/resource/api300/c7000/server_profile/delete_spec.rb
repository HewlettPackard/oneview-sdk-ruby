require 'spec_helper'

klass = OneviewSDK::API300::C7000::ServerProfile
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_300 }
  include_examples 'ServerProfileDeleteExample', 'integration api300 context'
end
