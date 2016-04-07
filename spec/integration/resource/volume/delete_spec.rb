require 'spec_helper'

RSpec.describe OneviewSDK::Volume, integration: true, type: DELETE, sequence: 1 do
  include_context 'integration context'

  before :all do
    @volume = OneviewSDK::Volume.new($client, name: VOLUME_NAME)
    @volume.retrieve!
  end

  describe '#delete' do
    it 'removes the snapshot' do
      expect { @volume.delete_snapshot(VOL_SNAPSHOT_NAME) }.to_not raise_error
    end

    it 'removes the volume' do
      expect { @volume.delete }.to_not raise_error
    end
  end
end
