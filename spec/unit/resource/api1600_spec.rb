require 'spec_helper'

RSpec.describe OneviewSDK::API1600 do
  it 'has a list of supported variants' do
    variants = described_class::SUPPORTED_VARIANTS
    expect(variants).to be_a Array
    %w[C7000 Synergy].each { |v| expect(variants).to include(v) }
  end

  it 'returns a valid API1600 variant' do
    %w[C7000 Synergy].each { |v| expect { OneviewSDK::API1600.const_get(v) }.not_to raise_error }
  end

  it 'raises an error when an invalid API1600 variant is called' do
    expect { OneviewSDK::API1600::C6000 }
      .to raise_error(NameError, 'The C6000 method or resource does not exist for OneView API1600 variant C7000.')
  end

  it 'has a default api variant' do
    expect(described_class::DEFAULT_VARIANT).to eq('C7000')
  end

#  describe '#resource_named' do
#    it 'gets the correct resource class' do
#      expect(described_class.resource_named('Enclosure')).to eq(described_class::Enclosure)
#    end

#    it 'allows you to override the variant' do
#      expect(described_class.resource_named('Enclosure', 'Synergy')).to eq(described_class::Synergy::Enclosure)
#      expect(described_class.resource_named('Enclosure', 'C7000')).to eq(described_class::C7000::Enclosure)
#    end
#  end

  describe '#variant' do
    it 'gets the current variant' do
      expect(described_class::SUPPORTED_VARIANTS).to include(OneviewSDK::API1600.variant)
    end
  end

  describe '#variant=' do
    it 'sets the current variant' do
      OneviewSDK::API1600.variant = 'Synergy'
      expect(OneviewSDK::API1600.variant).to eq('Synergy')
      expect(OneviewSDK::API1600.variant_updated?).to eq(true)
    end
  end
end
