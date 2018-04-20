require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::Switch do
  include_context 'shared context'

  it 'inherits from API500' do
    expect(described_class).to be < OneviewSDK::API500::C7000::Switch
  end
end
