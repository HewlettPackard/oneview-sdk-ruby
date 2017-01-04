require 'spec_helper'

RSpec.describe OneviewSDK::API300::ImageStreamer do
  describe '#resource_named' do
    it 'gets the correct resource class' do
      expect(described_class.resource_named('DeploymentPlans')).to eq(described_class::DeploymentPlans)
    end
  end
end
