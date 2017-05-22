require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::DriveEnclosure do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::DriveEnclosure' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::DriveEnclosure
  end
end
