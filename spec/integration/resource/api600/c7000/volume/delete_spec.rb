require 'spec_helper'

klass = OneviewSDK::API600::C7000::Volume
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_600 }
  include_examples 'VolumeDeleteExample', 'integration api600 context'
  include_examples 'VolumeDeleteExample API600', 'integration api600 context'
end
