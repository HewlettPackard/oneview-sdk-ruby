require 'spec_helper'

klass = OneviewSDK::API500::C7000::LogicalSwitchGroup
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::C7000::LogicalSwitchGroup' do
    expect(described_class).to be < OneviewSDK::API300::C7000::LogicalSwitchGroup
  end
end
