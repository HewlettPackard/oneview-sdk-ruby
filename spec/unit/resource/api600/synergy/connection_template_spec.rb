require 'spec_helper'

RSpec.describe OneviewSDK::API600::Synergy::ConnectionTemplate do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::Synergy::ConnectionTemplate' do
    expect(described_class).to be < OneviewSDK::API500::Synergy::ConnectionTemplate
  end
end
