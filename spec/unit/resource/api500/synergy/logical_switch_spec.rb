require 'spec_helper'

klass = OneviewSDK::API500::Synergy::LogicalSwitch
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::LogicalSwitch' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::LogicalSwitch
  end
end
