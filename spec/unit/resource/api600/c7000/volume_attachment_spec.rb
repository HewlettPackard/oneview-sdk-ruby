require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::VolumeAttachment do
  include_context 'shared context'

  it 'inherits from API300' do
    expect(described_class).to be < OneviewSDK::API300::C7000::VolumeAttachment
  end

  describe '#initialize' do
    it 'sets the defaults correctly api_ver 600' do
      item = described_class.new(@client_600)
      expect(item[:type]).to eq('StorageVolumeAttachmentV2')
    end
  end

  describe '#get_paths' do
    it 'is unavailable' do
      item = described_class.new(@client_600)
      expect { item.get_paths }.to raise_error(/The method #get_paths is unavailable for this resource/)
    end
  end

  describe '#get_path' do
    it 'is unavailable' do
      item = described_class.new(@client_600)
      expect { item.get_path }.to raise_error(/The method #get_path is unavailable for this resource/)
    end
  end
end
