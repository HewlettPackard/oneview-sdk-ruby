require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API300::PlanScripts
RSpec.describe klass do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      connection = klass.new(@client_i3s_300)
      expect(connection['type']).to eq('PlanScript')
    end
  end

  describe '#retrieve_differences' do
    it 'retrieves differences by id' do
      expect(@client_i3s_300).to receive(:rest_post).with('/rest/plan-scripts/differences/fake')
        .and_return(FakeResponse.new(response: 'fake'))
      item = klass.new(@client_i3s_300, uri: '/rest/plan-scripts/fake')
      expect(item.retrieve_differences).to eq('response' => 'fake')
    end
  end
end
