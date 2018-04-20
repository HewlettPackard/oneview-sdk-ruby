require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API600::PlanScript
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from AP500' do
    expect(described_class).to be < OneviewSDK::ImageStreamer::API500::PlanScript
  end

  describe '#retrieve_read_only' do
    it 'raises exception when uri is empty' do
      item = klass.new(@client_i3s_600)
      expect { item.retrieve_read_only }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'returns the response body from uri/usedby/readonly' do
      item = klass.new(@client_i3s_600, uri: '/rest/plan-scripts/fake')
      expect(@client_i3s_600).to receive(:rest_get)
        .with("#{item['uri']}/usedby/readonly", { 'Content-Type' => 'none' }, 600)
        .and_return(FakeResponse.new(response: 'fake'))
      expect(item.retrieve_read_only).to eq('response' => 'fake')
    end
  end
end
