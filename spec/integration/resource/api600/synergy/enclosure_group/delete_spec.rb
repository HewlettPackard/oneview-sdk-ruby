require 'spec_helper'

klass = OneviewSDK::API600::Synergy::EnclosureGroup
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_600_synergy }
  include_examples 'EnclosureGroupDeleteExample', 'integration api600 context', true
end
