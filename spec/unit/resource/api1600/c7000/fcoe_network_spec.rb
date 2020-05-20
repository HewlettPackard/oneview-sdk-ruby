require 'spec_helper'

RSpec.describe OneviewSDK::API1600::C7000::FCoENetwork do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1200::C7000::FCoENetwork' do
    expect(described_class).to be < OneviewSDK::API1200::C7000::FCoENetwork
  end
end
