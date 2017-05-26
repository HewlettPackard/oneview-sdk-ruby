require 'spec_helper'

klass = OneviewSDK::EnclosureGroup
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client }
  include_examples 'EnclosureGroupDeleteExample', 'integration context'
end
