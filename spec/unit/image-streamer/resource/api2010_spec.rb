require 'spec_helper'

RSpec.describe OneviewSDK::ImageStreamer::API2010 do
  describe '#resource_named' do
    it 'gets the correct resource class' do
      expect(described_class.resource_named('PlanScript')).to eq(described_class::PlanScript)
    end
  end
end
