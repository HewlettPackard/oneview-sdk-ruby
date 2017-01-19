require 'spec_helper'

RSpec.describe OneviewSDK::ImageStreamer::API300 do
  describe '#resource_named' do
    it 'gets the correct resource class' do
      expect(described_class.resource_named('DeploymentPlans')).to eq(described_class::DeploymentPlans)
    end
  end
end
