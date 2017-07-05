require 'spec_helper'

klass = OneviewSDK::Volume
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client }
  include_examples 'VolumeDeleteExample', 'integration context'
end
