require 'spec_helper'

klass = OneviewSDK::API600::C7000::Enclosure
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_600 }
  include_examples 'EnclosureDeleteExample', 'integration api600 context', 'C7000'
end
