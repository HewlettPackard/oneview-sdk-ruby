require 'spec_helper'

RSpec.describe OneviewSDK::API300 do
  it 'has a list of supported api versions' do
    versions = described_class::SUPPORTED_API300_VERSIONS
    expect(versions).to be_a Array
    ['C7000', 'Thunderbird'].each { |v| expect(versions).to include(v) }
  end

  it 'has a default api version' do
    expect(described_class::DEFAULT_API300_VERSION).to eq('C7000')
  end

  describe '#api_version' do
    it 'gets the current api_version' do
      expect(described_class::SUPPORTED_API300_VERSIONS).to include(OneviewSDK::API300.api300_version)
    end
  end

  describe '#api_version=' do
    it 'sets the current api_version' do
      OneviewSDK::API300.api300_version = 'Thunderbird'
      expect(OneviewSDK::API300.api300_version).to eq('Thunderbird')
      expect(OneviewSDK::API300.api300_version_updated?).to eq(true)
    end
  end
end
