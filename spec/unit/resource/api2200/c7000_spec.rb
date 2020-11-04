require 'spec_helper'

RSpec.describe OneviewSDK::API2200::C7000 do
  describe '#resource_named' do
    it 'calls the OneviewSDK::API2200.resource_named method' do
      expect(OneviewSDK::API2200).to receive(:resource_named).with('ConnectionTemplate', 'C7000')
      described_class.resource_named('ConnectionTemplate')
    end
  end
end
