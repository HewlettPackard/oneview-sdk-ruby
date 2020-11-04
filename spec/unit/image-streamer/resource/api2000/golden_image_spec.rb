require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API1600::GoldenImage
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API1600' do
    expect(described_class).to be < OneviewSDK::ImageStreamer::API1600::GoldenImage
  end
end
