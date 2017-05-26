require 'spec_helper'

klass = OneviewSDK::API500::C7000::EnclosureGroup
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_500 }
  include_examples 'EnclosureGroupDeleteExample', 'integration api500 context', true
end
