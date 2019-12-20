require 'spec_helper'

RSpec.describe OneviewSDK do

  it 'has a list of supported api versions' do
    versions = described_class::SUPPORTED_API_VERSIONS
    expect(versions).to be_a Array
    [200, 300, 500, 600, 800, 1000, 1200].each { |v| expect(versions).to include(v) }
  end

  it 'returns a valid API version' do
    %w[API200 API300 API500 API600 API800 API1000 API1200].each { |v| expect { OneviewSDK.const_get(v) }.not_to raise_error }
  end

  it 'raises an error when an invalid API300 version is called' do
    expect { OneviewSDK::API999 }.to raise_error(NameError,
                                                 'The API999 method or resource does not exist for OneView API version 200.')
  end

  it 'has a default api version' do
    expect(described_class::DEFAULT_API_VERSION).to eq(200)
  end

  describe '#api_version' do
    it 'gets the current api_version' do
      expect(described_class::SUPPORTED_API_VERSIONS).to include(OneviewSDK.api_version)
    end
  end

  describe '#api_version=' do
    it 'sets the current api_version' do
      OneviewSDK.api_version = 200
      expect(OneviewSDK.api_version).to eq(200)
      expect(OneviewSDK.api_version_updated?).to eq(true)
    end
  end
end
