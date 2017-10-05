require 'spec_helper'

klass = OneviewSDK::API300::C7000::Volume
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300 }
  include_examples 'VolumeUpdateExample', 'integration api300 context'
  include_examples 'VolumeSnapshotPoolUpdateExample', 'integration api300 context'
end
