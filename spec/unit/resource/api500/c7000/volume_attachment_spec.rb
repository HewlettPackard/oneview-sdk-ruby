require 'spec_helper'

RSpec.describe OneviewSDK::API500::C7000::VolumeAttachment do
  include_context 'shared context'

  it 'inherits from API300' do
    expect(described_class).to be < OneviewSDK::API300::C7000::VolumeAttachment
  end

  describe '#initialize' do
    it 'sets the defaults correctly api_ver 500' do
      item = described_class.new(@client_500)
      expect(item[:type]).to eq('StorageVolumeAttachmentV2')
    end
  end
end
