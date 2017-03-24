require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API300::PlanScript
RSpec.describe klass do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = klass.new(@client_i3s_300)
      expect(item['type']).to eq('PlanScript')
    end
  end

  describe '#retrieve_differences' do
    it 'raises exception when uri is empty' do
      item = klass.new(@client_i3s_300)
      expect { item.retrieve_differences }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'retrieves differences by id' do
      expect(@client_i3s_300).to receive(:rest_post)
        .with('/rest/plan-scripts/differences/fake', { 'Content-Type' => 'none' }, 300)
        .and_return(FakeResponse.new(response: 'fake'))
      item = klass.new(@client_i3s_300, uri: '/rest/plan-scripts/fake')
      expect(item.retrieve_differences).to eq('response' => 'fake')
    end
  end
end
