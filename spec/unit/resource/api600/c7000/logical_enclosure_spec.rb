require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::LogicalEnclosure do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::C7000::LogicalEnclosure' do
    expect(described_class).to be < OneviewSDK::API500::C7000::LogicalEnclosure
  end
end
