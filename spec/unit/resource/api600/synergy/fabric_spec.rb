require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::Fabric do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::Fabric' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::Fabric
  end
end
