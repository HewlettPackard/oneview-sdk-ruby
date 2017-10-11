require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::StoragePool do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::StoragePool
  end
end
