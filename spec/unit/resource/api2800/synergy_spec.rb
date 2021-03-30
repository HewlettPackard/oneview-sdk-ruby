require 'spec_helper'

RSpec.describe OneviewSDK::API2800::Synergy do
  describe '#resource_named' do
    it 'calls the OneviewSDK::API2800.resource_named method' do
      expect(OneviewSDK::API2800).to receive(:resource_named).with('ConnectionTemplate', 'Synergy')
      described_class.resource_named('ConnectionTemplate')
    end
  end
end
