require 'spec_helper'

RSpec.describe OneviewSDK::API500::C7000::UnmanagedDevice do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::C7000::UnmanagedDevice' do
    expect(described_class).to be < OneviewSDK::API300::C7000::UnmanagedDevice
  end
end
