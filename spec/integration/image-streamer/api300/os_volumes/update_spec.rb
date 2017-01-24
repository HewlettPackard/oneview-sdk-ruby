require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API300::OsVolumes
RSpec.describe klass, integration_i3s: true, type: UPDATE do
  include_context 'integration i3s api300 context'

  describe '#update' do
    it 'raises MethodUnavailable' do
      item = klass.new($client_i3s_300)
      expect { item.update }.to raise_error(/The method #update is unavailable for this resource/)
    end
  end
end
