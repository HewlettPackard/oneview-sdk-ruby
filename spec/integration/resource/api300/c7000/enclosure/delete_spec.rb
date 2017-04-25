require 'spec_helper'

klass = OneviewSDK::API300::C7000::Enclosure
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_300 }
  include_examples 'EnclosureDeleteExample', 'integration api300 context', 'C7000'
end
