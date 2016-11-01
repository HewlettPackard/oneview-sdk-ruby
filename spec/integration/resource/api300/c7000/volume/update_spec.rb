require 'spec_helper'

RSpec.describe OneviewSDK::Volume, integration: true, type: UPDATE do
  include_context 'integration context'

  before :all do
    @volume = OneviewSDK::Volume.new($client, name: VOLUME_NAME)
    @volume.retrieve!
  end

  describe '#snapshot' do
    it 'retrieve list' do
      expect(@volume.get_snapshots).not_to be_empty
    end

    it 'retrieve by name' do
      expect(@volume.get_snapshot(VOL_SNAPSHOT_NAME)).not_to be_empty
    end
  end
end
