require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API300::BuildPlan
RSpec.describe klass, integration_i3s: true, type: UPDATE do
  include_context 'integration i3s api300 context'

  describe '#update' do
    it 'updates the name of the plan script' do
      item = klass.find_by($client_i3s_300, name: BUILD_PLAN1_NAME).first
      expect(item['uri']).not_to be_empty
      item['name'] = BUILD_PLAN1_NAME_UPDATED
      expect { item.update }.not_to raise_error
      item.retrieve!
      expect(item['name']).to eq(BUILD_PLAN1_NAME_UPDATED)
    end
  end
end
