require 'spec_helper'

klass = OneviewSDK::API600::C7000::Volume
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_600 }
  include_examples 'VolumeUpdateExample', 'integration api600 context'
  include_examples 'VolumeSnapshotPoolUpdateExample API600', 'integration api600 context'
end
