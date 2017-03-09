require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::Resource do
  include_context 'shared context'

  it 'inherits from OneviewSDK::Resource' do
    expect(described_class).to be < OneviewSDK::Resource
  end
end
