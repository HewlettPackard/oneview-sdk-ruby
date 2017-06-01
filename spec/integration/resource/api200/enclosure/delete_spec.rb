require 'spec_helper'

klass = OneviewSDK::Enclosure
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client }
  include_examples 'EnclosureDeleteExample', 'integration context', 'C7000'
end
