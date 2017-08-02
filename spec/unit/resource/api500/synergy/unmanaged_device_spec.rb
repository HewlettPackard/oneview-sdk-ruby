require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::UnmanagedDevice do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::UnmanagedDevice' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::UnmanagedDevice
  end
end
