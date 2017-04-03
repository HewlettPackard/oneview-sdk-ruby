require 'spec_helper'

RSpec.describe OneviewSDK::API500::C7000::FCNetwork do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::C7000::FCNetwork' do
    expect(described_class).to be < OneviewSDK::API300::C7000::FCNetwork
  end
end
