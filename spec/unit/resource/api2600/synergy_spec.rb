require 'spec_helper'

RSpec.describe OneviewSDK::API2600::Synergy do
  describe '#resource_named' do
    it 'calls the OneviewSDK::API2600.resource_named method' do
      expect(OneviewSDK::API2600).to receive(:resource_named).with('ConnectionTemplate', 'Synergy')
      described_class.resource_named('ConnectionTemplate')
    end
  end
end
