require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API1600::ArtifactBundle
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API1020' do
    expect(described_class).to be < OneviewSDK::ImageStreamer::API1020::ArtifactBundle
  end
end
