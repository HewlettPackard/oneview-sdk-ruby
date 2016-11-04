require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::Volume
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  before :all do
    @volume = klass.new($client_300_thunderbird, name: VOLUME_NAME)
    @volume.retrieve!
    @volume_2 = klass.new($client_300_thunderbird, name: VOLUME2_NAME)
    @volume_2.retrieve!
    @volume_3 = klass.new($client_300_thunderbird, name: VOLUME3_NAME)
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
