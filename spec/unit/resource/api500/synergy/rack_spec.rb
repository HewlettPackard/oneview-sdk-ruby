require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::Rack do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::Rack' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::Rack
  end
end
