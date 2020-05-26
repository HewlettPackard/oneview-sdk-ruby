require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API1000::ArtifactBundle
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API800' do
    expect(described_class).to be < OneviewSDK::ImageStreamer::API800::ArtifactBundle
  end
end
