require 'spec_helper'

klass = OneviewSDK::API500::Synergy::Volume
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500_synergy }
  include_examples 'VolumeUpdateExample', 'integration api500 context'
  include_examples 'VolumeSnapshotPoolUpdateExample API500', 'integration api500 context'
end
