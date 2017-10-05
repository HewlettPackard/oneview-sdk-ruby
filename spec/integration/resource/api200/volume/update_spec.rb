require 'spec_helper'

RSpec.describe OneviewSDK::Volume, integration: true, type: UPDATE do
  let(:current_client) { $client }
  include_examples 'VolumeUpdateExample', 'integration context'
  include_examples 'VolumeSnapshotPoolUpdateExample', 'integration context'
end
