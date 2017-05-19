require 'spec_helper'

RSpec.describe OneviewSDK::API500::C7000::Switch do
  include_context 'shared context'

  it 'inherits from API300' do
    expect(described_class).to be < OneviewSDK::API300::C7000::Switch
  end
end
