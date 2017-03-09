require 'spec_helper'

RSpec.describe OneviewSDK::API500::C7000 do
  describe '#resource_named' do
    it 'calls the OneviewSDK::API500.resource_named method' do
      expect(OneviewSDK::API500).to receive(:resource_named).with('ConnectionTemplate', 'C7000')
      described_class.resource_named('ConnectionTemplate')
    end
  end
end
