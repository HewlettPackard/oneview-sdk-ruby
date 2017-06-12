require 'spec_helper'

klass = OneviewSDK::API500::C7000::LogicalSwitch
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::C7000::LogicalSwitch' do
    expect(described_class).to be < OneviewSDK::API300::C7000::LogicalSwitch
  end
end
