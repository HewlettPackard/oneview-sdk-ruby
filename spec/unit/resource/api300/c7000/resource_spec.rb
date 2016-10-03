require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::Resource do
  include_context 'shared context'

  it 'inherits from OneviewSDK::Resource' do
    expect(described_class).to be < OneviewSDK::Resource
  end
end
