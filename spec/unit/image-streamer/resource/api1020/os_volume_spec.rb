require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API1020::OSVolume
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API1000' do
    expect(described_class).to be < OneviewSDK::ImageStreamer::API1000::OSVolume
  end
end
