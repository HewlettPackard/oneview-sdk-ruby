require 'spec_helper'

RSpec.describe OneviewSDK::API600::Synergy::OSDeploymentPlan do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::OSDeploymentPlan' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::OSDeploymentPlan
  end
end
