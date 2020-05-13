require 'spec_helper'

RSpec.describe OneviewSDK::API1600::Synergy::Enclosure do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1200::Synergy::Enclosure' do
    expect(described_class).to be < OneviewSDK::API1200::Synergy::Enclosure
  end
end
