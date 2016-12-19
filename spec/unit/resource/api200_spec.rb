require 'spec_helper'

RSpec.describe OneviewSDK::API200 do
  describe '#resource_named' do
    it 'gets the correct resource class' do
      expect(described_class.resource_named('ServerProfile')).to eq(described_class::ServerProfile)
    end
  end
end
