require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::ConnectionTemplate do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::C7000::ConnectionTemplate' do
    expect(described_class).to be < OneviewSDK::API500::C7000::ConnectionTemplate
  end
end
