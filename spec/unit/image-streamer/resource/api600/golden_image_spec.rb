require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API600::GoldenImage
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API500' do
    expect(described_class).to be < OneviewSDK::ImageStreamer::API500::GoldenImage
  end
end
