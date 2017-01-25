require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API300::PlanScripts
RSpec.describe klass, integration_i3s: true, type: UPDATE do
  include_context 'integration i3s api300 context'

  describe '#update' do
    it 'updates the name of the plan script' do
      item = klass.find_by($client_i3s_300, name: PLAN_SCRIPT1_NAME).first
      expect(item['uri']).not_to be_empty
      item['name'] = PLAN_SCRIPT1_NAME_UPDATE
      expect { item.update }.not_to raise_error
      item.retrieve!
      expect(item['name']).to eq(PLAN_SCRIPT1_NAME_UPDATE)
    end
  end
end
