require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::ManagedSAN do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::C7000::ManagedSAN' do
    expect(described_class).to be < OneviewSDK::API500::C7000::ManagedSAN
  end
end
