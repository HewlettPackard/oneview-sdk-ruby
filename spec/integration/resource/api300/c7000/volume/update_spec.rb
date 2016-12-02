require 'spec_helper'

klass = OneviewSDK::API300::C7000::Volume
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  before :all do
    @volume = klass.new($client_300, name: VOLUME_NAME)
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
