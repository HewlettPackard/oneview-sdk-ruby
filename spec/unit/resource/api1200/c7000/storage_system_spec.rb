require 'spec_helper'

RSpec.describe OneviewSDK::API1200::C7000::StorageSystem do
  include_context 'shared context'

  let(:client) { @client_1200 }

  it 'inherits from OneviewSDK::API800::C7000::StorageSystem' do
    expect(described_class).to be < OneviewSDK::API800::C7000::StorageSystem
  end

  describe '#update' do
    it 'should call correct uri' do
      item = described_class.new(client, uri: '/rest/storage-systems/UUID-1')
      fake_response = FakeResponse.new
      expected_uri = item['uri'] + '/?force=true'
      item.data.delete('type')
      expect(client).to receive(:rest_put).with(expected_uri, { 'body' => item.data }, 1200).and_return(fake_response)
      item.update
    end

    context 'when storage system has not uri' do
      it 'should throw IncompleteResource error' do
        item = described_class.new(client, name: 'without uri')
        expect { item.update }.to raise_error(OneviewSDK::IncompleteResource)
      end
    end
  end
end
