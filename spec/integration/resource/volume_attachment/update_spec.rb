require 'spec_helper'

RSpec.describe OneviewSDK::VolumeAttachment, integration: true, type: UPDATE do
  include_context 'integration context'

  describe '#get_extra_unmanaged_volumes' do
    it 'list' do
      expect { OneviewSDK::VolumeAttachment.get_extra_unmanaged_volumes($client) }.to_not raise_error
    end
  end

  describe '#remove_extra_unmanaged_volume' do
    it 'remove' do
      expect { OneviewSDK::VolumeAttachment.get_extra_unmanaged_volumes($client) }.to_not raise_error
    end
  end

  describe '#get_path' do
    it 'get all' do
      item = OneviewSDK::VolumeAttachment.find_by($client, {}).first
      expect { item.get_paths }.to_not raise_error
    end
  end
end
