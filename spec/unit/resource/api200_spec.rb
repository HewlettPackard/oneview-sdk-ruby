require 'spec_helper'

RSpec.describe OneviewSDK::API200 do
  describe '#resource_named' do
    it 'calls the OneviewSDK.resource_named method' do
      expect(OneviewSDK).to receive(:resource_named).with('ServerProfile', 200)
      described_class.resource_named('ServerProfile')
    end

    it 'gets the correct resource class' do
      expect(described_class.resource_named('ServerProfile')).to eq(described_class::ServerProfile)
    end
  end
end
