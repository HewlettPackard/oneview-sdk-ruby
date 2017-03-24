require 'spec_helper'

RSpec.describe OneviewSDK::ImageStreamer::API300 do
  describe '#resource_named' do
    it 'gets the correct resource class' do
      expect(described_class.resource_named('DeploymentPlan')).to eq(described_class::DeploymentPlan)
    end
  end
end
