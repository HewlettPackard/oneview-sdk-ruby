require 'spec_helper'

RSpec.describe OneviewSDK::Volume, integration: true, type: DELETE, sequence: 1 do
  include_context 'integration context'

  before :all do
    @volume = OneviewSDK::Volume.new($client, name: VOLUME_NAME)
    @volume.retrieve!
    @volume_2 = OneviewSDK::Volume.new($client, name: VOLUME2_NAME)
    @volume_2.retrieve!
    @volume_3 = OneviewSDK::Volume.new($client, name: VOLUME3_NAME)
    @volume_3.retrieve!
  end

  describe '#delete' do
    it 'removes snapshots' do
      expect { @volume.delete_snapshot(VOL_SNAPSHOT2_NAME) }.to_not raise_error
    end

    it 'removes all the volumes' do
      expect { @volume.delete }.to_not raise_error
      expect { @volume_2.delete }.to_not raise_error
      expect { @volume_3.delete }.to_not raise_error
    end
  end
end
