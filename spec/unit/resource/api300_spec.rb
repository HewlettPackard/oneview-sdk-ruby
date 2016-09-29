require 'spec_helper'

RSpec.describe OneviewSDK::API300 do
  it 'has a list of supported api versions' do
    versions = described_class::SUPPORTED_API300_VERSIONS
    expect(versions).to be_a Array
    ['C7000', 'Thunderbird'].each { |v| expect(versions).to include(v) }
  end

  it 'returns a valid API300 version' do
    ['C7000', 'Thunderbird'].each { |v| expect{ OneviewSDK::API300::const_get(v) }.not_to raise_error }
  end

  it 'raises an error when an invalid API300 version is called' do
    expect{ OneviewSDK::API300::C6000 }.to raise_error(NameError,
                                                       'The C6000 method or resource does not exist for OneView API300 version C7000.')
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
