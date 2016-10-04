require 'spec_helper'

RSpec.describe OneviewSDK::API300 do
  it 'has a list of supported variants' do
    variants = described_class::SUPPORTED_VARIANTS
    expect(variants).to be_a Array
    %w(C7000 Thunderbird).each { |v| expect(variants).to include(v) }
  end

  it 'returns a valid API300 variant' do
    %w(C7000 Thunderbird).each { |v| expect { OneviewSDK::API300.const_get(v) }.not_to raise_error }
  end

  it 'raises an error when an invalid API300 variant is called' do
    expect { OneviewSDK::API300::C6000 }
      .to raise_error(NameError, 'The C6000 method or resource does not exist for OneView API300 variant C7000.')
  end

  it 'has a default api variant' do
    expect(described_class::DEFAULT_VARIANT).to eq('C7000')
  end

  describe '#resource_named' do
    it 'gets the correct resource class' do
      expect(described_class.resource_named('ServerProfile')).to eq(described_class::ServerProfile)
    end

    it 'allows you to override the variant' do
      expect(described_class.resource_named('ServerProfile', 'Thunderbird')).to eq(described_class::Thunderbird::ServerProfile)
      expect(described_class.resource_named('ServerProfile', 'C7000')).to eq(described_class::C7000::ServerProfile)
    end
  end

  describe '#variant' do
    it 'gets the current variant' do
      expect(described_class::SUPPORTED_VARIANTS).to include(OneviewSDK::API300.variant)
    end
  end

  describe '#variant=' do
    it 'sets the current variant' do
      OneviewSDK::API300.variant = 'Thunderbird'
      expect(OneviewSDK::API300.variant).to eq('Thunderbird')
      expect(OneviewSDK::API300.variant_updated?).to eq(true)
    end
  end
end
