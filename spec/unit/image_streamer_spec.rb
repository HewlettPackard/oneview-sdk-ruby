require 'spec_helper'

RSpec.describe OneviewSDK::ImageStreamer do

  it 'has a list of supported api versions' do
    versions = described_class::SUPPORTED_API_VERSIONS
    expect(versions).to be_a Array
    [300].each { |v| expect(versions).to include(v) }
  end

  it 'returns a valid API version' do
    %w(API300).each { |v| expect { OneviewSDK::ImageStreamer.const_get(v) }.not_to raise_error }
  end

  it 'raises an error when an invalid API300 version is called' do
    expect { OneviewSDK::ImageStreamer::API999 }
      .to raise_error(NameError, 'The API999 method or resource does not exist for Image Streamer API version 300.')
  end

  it 'has a default api version' do
    expect(described_class::DEFAULT_API_VERSION).to eq(300)
  end

  describe '#api_version' do
    it 'gets the current api_version' do
      expect(described_class::SUPPORTED_API_VERSIONS).to include(OneviewSDK::ImageStreamer.api_version)
    end
  end

  describe '#api_version=' do
    it 'sets the current api_version' do
      OneviewSDK::ImageStreamer.api_version = 300
      expect(OneviewSDK::ImageStreamer.api_version).to eq(300)
      expect(OneviewSDK::ImageStreamer.api_version_updated?).to eq(true)
    end
  end
end
